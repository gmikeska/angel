module Angel
  module Controllers
    class DesignsController < BaseController
      before_action :set_design

      def show
        @scope = "global"
        render "show"
      end

      def show_component
        render(partial:"design", locals:{design:@design})
      end

      def component_settings
        set_design
        @design.settings_scope(:user, current_user)
        @scope = "user"
        render(partial:"turbo_form", locals:{design:@design,scope:@scope})
      end

      def update
        scope_name = params[:design][:scope].to_sym
        options_data = @design.settings_scopes[scope_name].defaults
        data = {}
        options_data.each do |field_name, user_option|
          # binding.pry
          if(user_option.is_a?(Hash))
            data[field_name] = {}
            data[field_name] = params.require(:design).require(:user_options).require(field_name).permit(user_option[:value].symbolize_keys.keys).to_h.symbolize_keys
            if(user_option[:type].match?(/check_box/))
              data[field_name] = data[field_name].each{|k,v| data[field_name][k] = [false,true][v.to_i]}
            end
            data[field_name] = user_option[:value].merge(data[field_name])
          else
            data[field_name] = params.require(:design).require(:user_options).permit(f)
          end
        end
        options = {}
        options_data.each{|field_name, option| options[field_name] = {};options[field_name][:value] = data[field_name]; options[field_name] = option.merge(options[field_name]) }
        data.keys.each do |key|
          options_data[key][:value] = data[key]
        end
        @design.configure_scope(scope_name,options_data)
        if(@design.save)
          render(partial:"design", locals:{design:@design})
        else
          render(partial:"turbo_form", locals:{design:@design})
        end
      end

      def set_design
        super
        if(!!params[:page_id])
          set_page
        end
      end
    end
  end
end
