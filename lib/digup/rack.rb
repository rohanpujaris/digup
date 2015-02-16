module Digup

  class Rack

    def initialize(app)
      @app = app
    end

    def call(env)
      responder = Responder.new(@app.call(env))
      if Setting.enabled? && responder.valid?
        logger = Logger.new(responder)
        logger.log_all
        responder.append_javascript_to_evaluate_json if Setting.handle_json? && responder.html_response?
        responder.headers['Content-Length'] = responder.response_body.bytesize.to_s
        responder.clear_digup_message_store
        responder.build_response
      else
        responder.clear_digup_message_store
      end
      responder.build_response
    end

  end

end
