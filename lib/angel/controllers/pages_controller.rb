module Angel
  module Controllers
    class PagesController < BaseController
      before_action :set_page, except:%i[new create]


    end
  end
end
