require 'rails/generators/migration'

module Digup
  module Generators
    class ModelGenerator < Rails::Generators::Base

      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def create_digup_models
        template 'digup_log.rb', 'app/models/digup_log.rb'
        migration_template 'create_digup_log.rb', 'db/migrate/create_digup_log.rb'
        template 'request_response_info.rb', 'app/models/request_response_info.rb'
        migration_template 'create_request_response_info.rb', 'db/migrate/create_request_response_info.rb'
      end

    end
  end
end
