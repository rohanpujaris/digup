require 'rails/generators/migration'

module Digup
  module Generators
    class ViewGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      def create_hook
        copy_file '_hook.html.erb', 'app/views/digup/_hook.html.erb'
      end

    end
  end
end
