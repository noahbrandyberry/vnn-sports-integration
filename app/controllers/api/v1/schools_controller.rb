class Api::V1::SchoolsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_school, only: %i[ show upcoming_events recent_results ]

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
    @teams = @teams.where(level_id: params[:level_id]) if params[:level_id].present?
    @teams = @teams.where(gender_id: params[:gender_id]) if params[:gender_id].present?
    @teams = @teams.where(sport_id: params[:sport_id]) if params[:sport_id].present?
    @teams = @teams.where(id: params[:team_id]) if params[:team_id].present?
    event_ids = @teams.map{|team| team.team_events.map(&:event_id)}.flatten.uniq
    @events = Event.where(id: event_ids).includes(team_results: [:team]).includes(:result, :teams, :location, :team_events).uniq

    respond_to do |format|
      format.json
      format.ics do
        @calendar = Icalendar::Calendar.new
        calendar_name = @teams.count == 1 ? "#{@teams.first.name} Events" : "#{@school} Events"
        @calendar.append_custom_property("X-WR-CALNAME", calendar_name)
        @calendar.append_custom_property('X-APPLE-CALENDAR-COLOR', @school.primary_color)
        @events.each do |e|
          start = e.start.in_time_zone(e.location.try(:timezone) || 'America/New_York')
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

  def recent_results
    @teams = @school.current_teams
    @teams = @teams.where(id: params[:team_id]) if params[:team_id].present?
    @events = @teams.map{|team| team.events.includes(:result).where(start: 2.week.ago..Time.now).where.not(result: {id: nil}).last(1)}.flatten.uniq
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
