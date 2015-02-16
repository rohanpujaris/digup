require 'digup/setting'
require 'digup/rack'
require 'digup/template'
require 'digup/responder'
require 'digup/logger'
require 'digup/digup_railtie'
require 'digup/extension'

module Digup

  class << self
    attr_accessor :message_store

    def message_store
      @message_store ||= []
    end

    def html_message
      html = '<ul>'
      message_store.each do |record|
        html += '<li>'
        html += "#{record[:cursor_info]} => " if cursor_info?(record)
        html += "#{record[:message]}"
        html += '</li>'
      end
      (html + '</ul>').html_safe
    end

    def console_message
      console_data = ''
      message_store.each do |record|
        console_data += "#{record[:cursor_info]} : " if cursor_info?(record)
        console_data += "#{record[:message]}\\n"
      end
      console_data
    end

    def json_message(end_character)
      if end_character == ']'
        ", {\"digup\": #{message_store.to_json}}"
      else
        ", \"digup\": #{message_store.to_json}"
      end
    end

    def text_message
      text = ''
      message_store.each do |record|
        text += "\n#{record[:cursor_info]} : "
        text += "#{record[:message]}"
      end
      text
    end

    def write_up(message, args=nil)
      message_hash = {:date => Time.now, :message => message}
      message_hash.merge!(:cursor_info => caller[0].sub(Rails.root.to_s, ''))
      message_store.push(message_hash)
    end

    alias_method :log, :write_up

    def cursor_info?(record)
      Setting.cursor_info? && record[:cursor_info]
    end
  end

end
