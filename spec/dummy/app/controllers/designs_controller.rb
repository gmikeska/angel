class DesignsController < Angel::Controllers::DesignsController
  layout "application"
  def edit
    set_design
    render :turbo_form
  end

  def current_user
    User.first
  end
  def set_design
    args = (params[:id].nil? && params[:name].present?) ? {name:params[:name]} : {id:params[:id]}
    @design = Design.find_by(**args)
    @design.user = current_user
    if(!!params[:page_id])
      set_page
    end
  end
end
