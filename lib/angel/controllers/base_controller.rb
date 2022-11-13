module Angel
  module Controllers
    class BaseController < ActionController::Base
      # def index
      #
      # end

      def set_design(**args)
        args[:id] = params[:id] if(args.keys.length == 0)
        @design = Design.find_by(**args)
      end

      def set_group(id:nil)
        id = params[:id] if(id.nil? && !!params[:id])
        @group = Group.find(id)
      end

      def current_page
        return @page
      end

      def current_group
        return @group
      end

      def set_page
        if(params[:page_id])
          @page = Page.find(params[:page_id])
        else
          @page = Page.where(controller:params[:controller], action:params[:action])
        end
      end
    end
  end
end
