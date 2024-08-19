class Admin::EventsController < ApplicationController
  layout "admin"
  before_action :set_event, only: %i[show edit update destroy]
  before_action :set_team

  # GET /events or /events.json
  def index
    @events = @team.events
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @player = @team.events.build
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = @team.events.build(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to admin_team_event_url(@team, @event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to admin_team_event_url, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to admin_team_events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  def set_team
    @team = Team.find(params[:team_id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :start, :location_id, :location_name)
  end
end
