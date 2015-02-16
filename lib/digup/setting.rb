module Digup

  class Setting

    RESPONSE_TYPE = [:js, :json, :html]
    LOG_TO = [:console, :html_body, :db, :file]
    BOOLEAN_SETTINGS = [:cursor_info]
    DEFAULT_SETTINGS = {
      :response_type => [:js, :json, :html],
      :log_to => [:console, :html_body],
      :cursor_info => true
    }

    class << self
      attr_accessor :options

      def build_functions
        RESPONSE_TYPE.each do |rt|
          self.class.send(:define_method, "handle_#{rt}?") { options[:response_type].include?(rt) }
        end

        LOG_TO.each do |lt|
          self.class.send(:define_method, "log_to_#{lt}?") { options[:log_to].include?(lt) }
        end

        BOOLEAN_SETTINGS.each do |s|
          self.class.send(:define_method, "#{s}?") { options[s] }
        end
      end

      def enabled?
        @options.present?
      end

      def options=(options)
        if options.is_a? Hash
          options.slice!(:response_type, :log_to, :cursor_info)
          options[:response_type] = option_to_array(options, :response_type)
          options[:log_to] = option_to_array(options, :log_to)
          @options = DEFAULT_SETTINGS.merge(options)
        elsif options == :default
          @options = DEFAULT_SETTINGS
        end
        build_functions
      end

      def option_to_array(options, key)
        return DEFAULT_SETTINGS[key] unless options[key]
        if options[key].is_a? Array
          options[key]
        else
          [options[key]]
        end & DEFAULT_SETTINGS[key]
      end

      def content_type_to_handle
        content_type = []
        content_type << 'text/html' if handle_html?
        content_type << 'text/javascript' if handle_js?
        content_type << 'application/json' if handle_json?
        content_type
      end

    end

  end

end
