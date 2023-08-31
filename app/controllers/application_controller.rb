class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_action :set_current_school, if: :devise_controller?

  private

  def layout_by_resource
    if devise_controller?
      "admin"
    else
      "application"
    end
  end

  def set_current_school
    @current_school = School.find(session[:school_id])

    unless @current_school
      @current_school = School.new(
        logo_url: ActionController::Base.helpers.image_path('Logo.png'),
        primary_color: 'grey'
      )
    end
  end

  def require_current_school
    set_current_school
    redirect_to admin_schools_url unless @current_school.persisted?
  end
end
