class Api::V1::TeamsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_school
  before_action :set_team, only: %i[ show ]


  # GET /teams
  # GET /teams.json
  def index
    @teams = @school.teams.includes(program: [:gender, :sport]).includes(:year, :season, :level, :gender, :sport)
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = @school.teams.find(params[:id])
    end

    def set_school
      @school = School.find(params[:school_id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:name, :label, :photo_url, :home_description, :hide_gender)
    end
end
