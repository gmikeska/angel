# frozen_string_literal: true

# require 'generators/generator_helpers.rb'

module Angel
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path("templates", __dir__)
      # option :options_model, type: :string, default: 'user'
      def self.next_migration_number(path)
          unless @prev_migration_nr
            @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
          else
            @prev_migration_nr += 1
          end
          @prev_migration_nr.to_s
      end
      def create_views_directory
        copy_file "show.html.erb", "app/views/angel/#{file_name}.html.erb"
      end
      def generate_migrations
        migration_template "migrations/create_designs.rb", "db/migrate/create_designs.rb"
        migration_template "migrations/create_pages.rb", "db/migrate/create_pages.rb"
      end
      def generate_models
        template "models/design.rb", "app/models/design.rb"
        template "models/page.rb", "app/models/page.rb"
      end
      def add_js
        template "javascript/controllers/component_controller.js", "app/javascript/controllers/component_controller.js"

      end
      def add_component_options_methods
        inject_into_file "app/models/#{options_model}.rb", after: "class #{options_model.classify}\n" do %Q(
  def component_options(key)
    if(!!options_data[key])
      data = options_data[key]
      if(data.is_a?(Hash))
        return data.symbolize_keys
      else
        return data
      end
    else
      return {}
    end
  end
)
end



        def set_component_options(key, data)
          options_data[key] = data
          save()
        end
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
            resources :designs do
              get "component", to:"designs#show_component", as:"page_design_component"
            end
          end
          resources :designs do
            get "component", to:"designs#show_component", as:"design_component"
          end
          resources :designs)
        route nested_resources
      end
    end
  end
end
