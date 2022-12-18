module Angel
  module Controllers
    class DesignsController < BaseController
      before_action :set_design

      def show
        render(partial:"design")
      end

      def show_component
        render(partial:"design", locals:{design:@design})
      end

      def component_settings
        render(partial:"turbo_form", locals:{design:@design})
      end

      def update
        options_data = @design.user_options
        data = {}
        options_data.each do |field_name, user_option|
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
        @design.user_options = options_data
        if(@design.save)
          render(partial:"design", locals:{design:@design})
        else
          render(partial:"turbo_form", locals:{design:@design})
        end
      end

      def set_design
        search_params = (params[:id].nil? && params[:name].present?) ? {name:params[:name]} : {id:params[:id]}
        super(**search_params)

        if(!!params[:page_id])
          set_page
        end
      end
    end
  end
end
