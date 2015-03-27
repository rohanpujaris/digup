module Digup

  class Logger

    def self.file_path
      Rails.root.join('log', 'digup.log').to_s
    end

    def initialize(responder)
      @responder = responder
    end

    # appends log as html footer
    def log_to_html_body
      template = case
        when @responder.html_response?
          Template.html_template
        when @responder.javascript_response?
          Template.javascript_template
        else
          new_json_template
      end
      @responder.append_template_to_response(template)
    end

    # appends log as web console
    def log_to_console
      template = case
        when @responder.html_response?
          Template.console_template_for_html_response
        when @responder.javascript_response?
          Template.console_template_for_javascript_response
        when !Setting.log_to_html_body?
          new_json_template
      end
      @responder.append_template_to_response(template) if template
    end

    # Add log to database. ActiveRecord required
    def log_to_db
      RequestResponseInfo.create(
        :request_method => @responder.request.request_method,
        :request_accepts => @responder.request.accepts,
        :response_type => @responder.content_type,
        :response_status => @responder.status,
        :params => @responder.request.filtered_parameters
      ).digup_logs.create(Digup.message_store)
    end

    # add log to file inside log/digup.log
    def log_to_file
      File.open(Logger.file_path, 'a') do |f|
        f.write(Template.file_template(@responder))
      end
    end

    # log to every available option
    def log_all
      if Digup.message_store.present?
        log_to_html_body if Setting.log_to_html_body?
        log_to_console if Setting.log_to_console?
        log_to_db if Setting.log_to_db?
        log_to_file if Setting.log_to_file?
      end
    end

    def response_body
      @responder.response_body
    end

    # creates json template depending on the last character of response(} or ])
    def new_json_template
      Template.json_template(response_body[response_body.length - 1])
    end

  end

end
