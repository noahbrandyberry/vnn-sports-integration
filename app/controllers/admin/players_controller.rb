class Admin::PlayersController < ApplicationController
  before_action :authenticate_admin!
  before_action :require_current_school
  before_action :set_team
  before_action :set_player, only: %i[ show edit update destroy ]
  layout 'admin'

  # GET /players
  def index
    @players = @team.players
  end

  # GET /players/1
  def show
  end

  # GET /players/new
  def new
    @player = @team.players.build
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  def create
    @player = @team.players.build(player_params)

    respond_to do |format|
      if @player.save
        format.turbo_stream
        format.html { redirect_to admin_team_player_url(@team, @player), notice: "Player was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to admin_team_player_url(@team, @player), notice: "Player was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  def destroy
    @player.destroy

    respond_to do |format|
      format.html { redirect_to admin_players_url, notice: "Player was successfully destroyed." }
      format.turbo_stream
    end
  end

  private
    def set_team
      @team = @current_school.teams.find(params[:team_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = @team.players.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:first_name, :last_name, :grad_year, :jersey, :position, :height, :weight)
    end
end
