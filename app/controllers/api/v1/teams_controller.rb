class Api::V1::TeamsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_school, except: %i[teams_by_ids recent_results live_games upcoming_events]
  before_action :set_team, only: %i[show]

  # GET /teams
  # GET /teams.json
  def index
    @teams = @school.teams.where(year: Year.last).where.not(gender_id: nil).includes(program: %i[gender sport]).includes(events: %i[result team_events]).includes(
      :year, :season, :level, :gender, :sport, :images, :players
    )
  end

  def live_games
    @teams = Team.where(id: params[:team_id])
    @events = @teams.map do |team|
      [team, team.events.includes(:result).where(start: 4.hours.ago..20.hour.from_now).first]
    end
  end

  def recent_results
    @teams = Team.where(id: params[:team_id])
    @events = @teams.map do |team|
      [team, team.events.includes(:result).where(start: 2.week.ago..Time.now).where.not(result: { id: nil }).first]
    end
  end

  def teams_by_ids
    @teams = Team.where(id: params[:team_id]).where.not(gender_id: nil).includes(program: %i[gender sport]).includes(events: %i[result team_events]).includes(
      :year, :season, :level, :gender, :sport, :images, :players
    )
    render :index
  end

  def upcoming_events
    @teams = Team.where(id: params[:team_id])
    @teams = @teams.where(level_id: params[:level_id]) if params[:level_id].present?
    @teams = @teams.where(gender_id: params[:gender_id]) if params[:gender_id].present?
    @teams = @teams.where(sport_id: params[:sport_id]) if params[:sport_id].present?
    @teams = @teams.where(id: params[:team_id]) if params[:team_id].present?
    event_ids = @teams.map { |team| team.team_events.map(&:event_id) }.flatten.uniq
    @events = Event.where(id: event_ids).includes(team_results: [:team]).includes(:result, :teams, :location,
                                                                                  :team_events).uniq

    respond_to do |format|
      format.json
      format.ics do
        @calendar = Icalendar::Calendar.new
        calendar_name = @teams.count == 1 ? "#{@teams.first.name} Events" : "School Sports Events"
        @calendar.append_custom_property("X-WR-CALNAME", calendar_name)
        @events.each do |e|
          start = e.start.in_time_zone(e.location.try(:timezone) || "America/New_York")
          team = @teams.to_a.intersection(e.teams).first
          opponent_name = e.team_events.to_a.find { |team_event| team_event.team_id === team.id }.try(:opponent_name)
          opponents = e.teams - [team]

          event = Icalendar::Event.new
          event.dtstart = start
          event.dtend = start + 2.hours
          description = ""
          if team && (opponents.length === 1 || opponent_name)
            event.summary = "#{team.name} vs #{opponents[0] ? opponents[0].name : opponent_name}"
            description += "Details: #{e.name}\n\n"
          else
            event.summary = "#{team.name} - #{e.name}"
          end

          description += "This event is up to date as of #{e.updated_at.in_time_zone(e.location.try(:timezone) || 'America/New_York').strftime('%D %l:%M %p %Z')}"
          event.description = description

          event.location = e.location.try(:format_address)
          event.uid = e.id.to_s

          @calendar.add_event(event)
        end

        @calendar.publish
      end
    end
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
