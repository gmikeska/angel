class ApplicationController < ActionController::Base

  def current_page
    return Page.find_or_create_by(controller:params[:controller],action:params[:action])
  end
end
