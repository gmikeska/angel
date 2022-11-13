module Angel
  module Controllers
    class DesignsController < BaseController
      before_action :set_design

      def show
        render(partial:"design")
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
