module Angel
  module Controllers
    class BaseController < ActionController::Base
      # def index
      #
      # end

      def set_design
        args = (params[:id].nil? && params[:name].present?) ? {name:params[:name]} : {id:params[:id]}
        @design = Design.find_by(**args)
      end

      def current_page
        return @page
      end

      def set_page
        if(!!params[:page_id])
          @page = Page.find(params[:page_id])
        else
          @page = Page.where(controller:params[:controller], action:params[:action])
        end
      end
    end
  end
end
