module Digup

  class Template

    HTML_TEMPLATE_FORMAT = <<-HTML
      <div class='digup-content'>
        <div class='digup-html-message'>
          {notification_message}
        </div>
      </div>
    HTML

    class << self

      # hook.html.haml is appended to response
      # html_message and message_store is passed as locals to view which can be used
      # to design custom template for displaying log.
      # html_message is inside li tag so its prefered to use it instead of raw log in message_store
      def html_template
        begin
          ApplicationController.new.render_to_string(
            :partial => 'digup/hook',
            :locals => {
              :html_message => Digup.html_message,
              :message_store => Digup.message_store
            }
          )
        rescue
          HTML_TEMPLATE_FORMAT.sub('{notification_message}', Digup.html_message)
        end.html_safe
      end

      def javascript_template
        code = <<-CODE
          if ($('.digup-html-message').length) {
            $('.digup-html-message').html("#{Digup.html_message}")
          } else {
            $('body').append("#{html_template.squish}")
          }
        CODE
        code.html_safe
      end

      # code for printing log in console when response is js
      def console_template_for_javascript_response
        code = <<-CODE
          if (typeof(console) !== 'undefined' && console.log) {
            if (console.groupCollapsed && console.groupEnd) {
              console.groupCollapsed('Digup');
              console.log("#{Digup.console_message}");
              console.groupEnd();
            } else {
              console.log("#{Digup.console_message}");
            }
          }
        CODE
        code.html_safe
      end

      # code for printing log in console when response is html.
      # console_template_for_javascript_response is enclosed in script tag
      def console_template_for_html_response
        code = <<-CODE
        <script type='text/javascript'>
          #{console_template_for_javascript_response}
        </script>
        CODE
      end

      # json message to be appended is decided depending on last character(} or ])
      def json_template(end_character)
        Digup.json_message(end_character).html_safe
      end

      # This code is appended to every page if Setting response_type includes :json
      def javascript_template_to_evaluate_json
        executable_javascript = ''
        if Setting.log_to_html_body?
          executable_javascript = <<-CODE
            if (!$('.digup-html-message').length) {
              $('body').append("#{html_template.squish}")
            }
            var list = '<ul>'
            $.each(digupData, function(index, value) {
              list += #{html_for_json_evaluation}
            })
            list += '</ul>'
            $('.digup-html-message').html(list)
          CODE
        end
        executable_javascript += console_template_for_javascript_response if Setting.log_to_console?
        code = <<-CODE
          <script type='text/javascript'>
            $(document).bind("ajaxComplete", function(event, xhr, settings){
              try {
                var jsonResponse = JSON.parse(xhr.responseText);
              } catch(e) {}
              if (typeof jsonResponse !== 'undefined') {
                if ($.isArray(jsonResponse)) {
                  digupData = jsonResponse[jsonResponse.length - 1].digup
                  } else {
                  digupData = jsonResponse.digup
                }
                #{executable_javascript}
              }
            });
          </script>
        CODE
      end

      def html_for_json_evaluation
        list = ''
        if Setting.cursor_info?
          list += "'<li>' + value['cursor_info'] + ' : ' + value['message'] + '</li>'"
        else
          list += "'<li>' + value['message'] + '</li>'"
        end
      end

      # template for logginf in log/digup.log
      def file_template(responder)
        file_log = "Time #{Time.now}\n"
        file_log += "Request method: #{responder.request.request_method} | "
        file_log += "Request accepts: #{responder.request.accepts}\n"
        file_log += "response status: #{responder.status} | "
        file_log += "response type: #{responder.response.content_type}\n"
        file_log += "params: #{responder.request.filtered_parameters}"
        file_log += Digup.text_message
        file_log += "\n\n#{'=' * 180}\n\n"
      end

    end

  end

end
