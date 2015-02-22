module Digup

  class Responder

    attr_accessor :status, :headers, :response, :response_body

    def initialize(original_response)
      @original_response = original_response
      @status, @headers, @response = original_response
    end

    def request
      response.request
    end

    # Appends template to reponse depending on the settings
    def append_template_to_response(template)
      position = if response_body.include?('</body>')
        response_body.rindex('</body>')
      else
        json_response? ? response_body.length - 1 : response_body.length
      end
      response_body.insert(position, (json_response? ? '' : "\n") + template )
    end

    # Appends javascript to every page when response_type Setting includes :json
    # Appends javascript to display json response appendes to original response
    def append_javascript_to_evaluate_json
      if response_body.include?('</body>')
        position = response_body.rindex('</body>')
        response_body.insert(position, Template.javascript_template_to_evaluate_json)
      else
        response_body << Template.javascript_template_to_evaluate_json
      end
    end

    def response_not_a_file?
      headers["Content-Transfer-Encoding"] != "binary"
    end

    def empty_response?
      (@response.is_a?(Array) && @response.size <= 1) ||
      !@response.respond_to?(:body) ||
      !response_body.respond_to?(:empty?) ||
      response_body.empty?
    end

    # If responsder is valid, then only response is modified
    def valid?
      !empty_response? && !response_body.frozen? && response_not_a_file? &&
      status == 200  && can_handle_response?
    end

    # build a response to be sent to client
    def build_response
      valid? ? [status, headers, [response_body]] : @original_response
    end

    # clears log message and reponse_type unless its not a redirection
    # If its redirection log needs to be displayed on redirected page. So its not cleared
    def clear_parameters
      unless [301, 302].include?(status)
        Digup.clear_all
      end
    end

    def response_body
      @response_body ||= response.body.instance_of?(Array) ? response.body.first : response.body
    end

    def can_handle_response?
      Setting.content_type_to_handle.include?(response.content_type)
    end

    def html_response?
      if Digup.response_type.present?
        Digup.response_type == :html
      else
        response.content_type == 'text/html'
      end
    end

    def javascript_response?
      if Digup.response_type.present?
        Digup.response_type == :js
      else
        response.content_type == 'text/javascript'
      end
    end

    def json_response?
      if Digup.response_type.present?
        Digup.response_type == :json
      else
        response.content_type == 'application/json'
      end
    end

  end

end
