class ApplicationController < ActionController::Base
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
