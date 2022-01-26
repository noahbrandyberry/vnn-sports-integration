class Api::V1::EventsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_school
  before_action :set_team
  before_action :set_event, only: %i[ show ]

  # GET /events
  # GET /events.json
  def index
    @events = @team.events.includes(:team_results, :result, :teams, :location, :team_events)
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = @team.events.find(params[:id])
    end

    def set_team
      @team = @school.teams.find(params[:team_id])
    end

    def set_school
      @school = School.find(params[:school_id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :event_type, :start, :tba, :result_type, :conference, :scrimmage, :location_verified, :private_notes, :public_notes, :bus_dismissal_datetime_local, :bus_departure_datetime_local, :bus_return_datetime_local, :home, :canceled, :postponed, :location_id, :host_team_id)
    end
end
