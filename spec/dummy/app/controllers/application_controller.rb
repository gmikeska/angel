class ApplicationController < ActionController::Base

  def current_user # this is a patch to replace devise in the specapp
    User.first
  end
  def current_page
    return Page.find_or_create_by(controller:params[:controller],action:params[:action])
  end
end
