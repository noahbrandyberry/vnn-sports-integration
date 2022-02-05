class Api::V1::SchoolsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_school, only: %i[ show upcoming_events ]

  # GET /schools
  # GET /schools.json
  def index
    @schools = School.all.includes(:location)
  end

  # GET /schools/1
  # GET /schools/1.json
  def show
  end

  # GET /schools/1/upcoming_events
  # GET /schools/1/upcoming_events.json
  def upcoming_events
    @teams = @school.current_teams
    event_ids = @teams.map{|team| team.team_events.map(&:event_id)}.flatten.uniq
    @events = Event.where(id: event_ids).includes(team_results: [:team]).includes(:result, :teams, :location, :team_events).uniq
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school
      @school = School.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def school_params
      params.require(:school).permit(:name, :mascot, :is_vnn, :url, :logo_url, :anti_discrimination_disclaimer, :registration_text, :registration_url, :primary_color, :secondary_color, :tertiary_color, :enrollment, :athletic_director, :phone, :email, :blog, :sportshub_version, :version, :instagram, :onboarding)
    end
end
