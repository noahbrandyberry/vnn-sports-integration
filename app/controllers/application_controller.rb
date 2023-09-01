class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_action :set_current_school
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  def layout_by_resource
    if devise_controller?
      "admin"
    else
      "application"
    end
  end

  def unset_school
    @current_school = School.new(
      logo_url: ActionController::Base.helpers.image_path('Logo.png'),
      primary_color: 'grey',
      name: 'My Schools Sports'
    )

    session[:school_id] = nil
  end

  def set_current_school
    if admin_signed_in?
      schools = current_admin.schools
      if session[:school_id]
        schools = schools.where(id: session[:school_id])
      end
      @current_school = schools.first

      if @current_school
        session[:school_id] = @current_school.id
      else
        unset_school
      end
    else
      unset_school
    end
  end

  def require_current_school
    set_current_school
    redirect_to admin_schools_url unless @current_school.persisted?
  end
end
