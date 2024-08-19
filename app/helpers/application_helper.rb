module ApplicationHelper
  def selected_year_id
    session[:year_id] ||= Year.last.id
  end
end
