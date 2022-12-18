# frozen_string_literal: true

# require 'generators/generator_helpers.rb'

module Angel
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path("templates", __dir__)
      def self.next_migration_number(path)
          unless @prev_migration_nr
            @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
          else
            @prev_migration_nr += 1
          end
          @prev_migration_nr.to_s
      end
      def generate_migrations
        migration_template "migrations/create_designs.rb", "db/migrate/create_designs.rb"
        migration_template "migrations/create_pages.rb", "db/migrate/create_pages.rb"
      end
      def generate_models
        template "models/design.rb", "app/models/design.rb"
        template "models/page.rb", "app/models/page.rb"
      end
      def generate_controllers
        template "controllers/designs_controller.rb", "app/controllers/designs_controller.rb"
        template "controllers/pages_controller.rb", "app/controllers/pages_controller.rb"
      end
      def generate_components
        template "components/table_component.rb", "app/components/table_component.rb"
        template "components/record_component.rb", "app/components/record_component.rb"
        template "components/site_nav_component.rb", "app/components/site_nav_component.rb"
        copy_file "components/table_component.html.erb", "app/components/table_component.html.erb"
        copy_file "components/record_component.html.erb", "app/components/record_component.html.erb"
        copy_file "components/site_nav_component.html.erb", "app/components/site_nav_component.html.erb"
      end
      def generate_routes
        nested_resources = %Q(
          resources :pages do
            resources :groups do
              resources :designs
            end
          end
          resources :groups do
            resources :designs
          end
          resources :designs)
        route nested_resources
      end

    end
  end
end
