class Admin::TeamsController < ApplicationController
  before_action :authenticate_admin!
  before_action :require_current_school
  before_action :set_team, only: %i[show edit update destroy]
  layout "admin"

  # GET /teams or /teams.json
  def index
    @teams = @current_school.teams.where(year: selected_year_id).includes(:season, :players, :events)
  end

  # GET /teams/1 or /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = @current_school.teams.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams or /teams.json
  def create
    @team = @current_school.teams.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to admin_team_url(@team), notice: "Team was successfully created." }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to admin_team_url(@team), notice: "Team was successfully updated." }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy

    respond_to do |format|
      format.html { redirect_to admin_teams_url, notice: "Team was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = @current_school.teams.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def team_params
    params.require(:team).permit(:name, :photo_url, :home_description, :year_id, :season_id, :level_id, :sport_id,
                                 :gender_id)
  end
end
