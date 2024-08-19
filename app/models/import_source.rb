class ImportSource < ApplicationRecord
  belongs_to :school
  belongs_to :sport, optional: true
  belongs_to :gender, optional: true
  belongs_to :level, optional: true
  belongs_to :year
  has_many :events, dependent: :destroy
  validates :url, presence: true
  validates :year_id, presence: true
  validates :frequency_hours, presence: true, numericality: { greater_than_or_equal_to: 6, less_than_or_equal_to: 168 }

  def fetch_calendar
    if url.present?
      client = Faraday.new(url: url) do |client|
        client.request :url_encoded
        client.adapter Faraday.default_adapter
      end
      response = client.get.body

      calendar = Icalendar::Calendar.parse(response).first

      calendar_name = calendar.ip_name.try(:first) || ""

      self.name = calendar_name if calendar_name
      return calendar
    end
    Icalendar::Calendar.new
  end

  def possible_teams
    teams = school.teams.includes(:level, :sport, :gender).where(year: year_id)
    teams = teams.where(sport: sport) if sport
    teams = teams.where(gender: gender) if gender
    teams = teams.where(level: level) if level
    teams
  end

  def preview
    teams = possible_teams
    fetch_calendar.events.each do |event|
      add_event event, teams
    end
  end

  def sync
    events.destroy_all
    teams = possible_teams
    fetch_calendar.events.each do |event|
      add_event event, teams, true
    end
    self.last_import_time = DateTime.now
    save
  end

  def add_event(event, teams, sync = false)
    description = event.description || ""
    if level && sport && gender
      team = teams.first
      if team
        add_event_with_team event, team, sync
      else
        handle_missing_event event, sync
      end
    else
      event_length = events.length

      event_results = teams.map do |team|
        cloned_event = event.clone

        matching_sport = if sport
                           true
                         else
                           !!description.match(/\b#{team.sport}\b/) || !!name.match(/\b#{team.sport}\b/)
                         end

        if level
          matching_level = true
        else
          level_abbreviations = team.level.abbreviations
          abbreviation = level_abbreviations.find { |a| description.match(/\b#{a}\b/) }
          if abbreviation
            matching_level = true
            cloned_event.dtstart = cloned_event.dtstart.in_time_zone(school.timezone)
            time = description.match(/\b#{abbreviation}\b - (\d{1,2}:\d{2})\b/).try(:[], 1)
            if time
              hours = time.split(":")[0].to_i
              minutes = time.split(":")[1].to_i
              hours += 12 if cloned_event.dtstart.strftime("%P") == "pm"
              cloned_event.dtstart = cloned_event.dtstart.change({ hour: hours, min: minutes })
            end
          else
            matching_level = !!name.match(/\b#{team.level}\b/)
          end
        end

        matching_gender = if gender
                            true
                          else
                            !!description.match(/\b#{team.gender}\b/) || !!name.match(/\b#{team.gender}\b/)
                          end

        add_event_with_team cloned_event, team, sync if matching_sport && matching_level && matching_gender
        { matching_sport: matching_sport, matching_level: matching_level, matching_gender: matching_gender }
      end

      handle_missing_event event, sync, event_results if events.length == event_length && !sync
    end
  end

  def add_event_with_team(event, team, sync)
    if sync && event.location
      short = event.location.length < 5

      if short && school.location
        location_results = if event.location.present?
                             Geocoder.search("#{event.location} #{school.location.city}",
                                             locationbias: "point:#{school.location.latitude},#{school.location.longitude}")
                           else
                             []
                           end
      else
        location_results = event.location.present? ? Geocoder.search(name: event.location) : []
      end
      location_result = location_results.first

      timezone = Timezone["America/New_York"]

      if location_result && location_result.place_id
        location_place = Geocoder.search(location_result.place_id, lookup: :google_places_details).first
        if location_place && location_place.street_address.present?
          timezone = Timezone.lookup(location_place.latitude, location_place.longitude)
          new_location_record = Location.new(
            name: location_place.data["name"],
            address_1: location_place.street_address,
            city: location_place.city,
            state: location_place.state,
            zip: location_place.postal_code,
            latitude: location_place.latitude,
            longitude: location_place.longitude,
            timezone: timezone.name
          )
          home = school.location.distance_to(new_location_record) < 2
          unless new_location_record.name
            new_location_record.name = home ? school.location.name : event.summary
          end
        end
      end
    end

    events.build(
      start: event.dtstart,
      name: event.summary,
      location_name: event.location,
      location: event.location ? new_location_record : school.location,
      team_events: [
        team.team_events.build(opponent_name: event.summary, home: home)
      ]
    )
  end

  def handle_missing_event(event, sync, event_results = [])
    missing = []
    if event_results.length > 0
      missing << "sport" if event_results.all? { |result| !result[:matching_sport] }
      missing << "level" if event_results.all? { |result| !result[:matching_level] }
      missing << "gender" if event_results.all? { |result| !result[:matching_gender] }
      message =  "Unable to detect #{missing.to_sentence} from: \"#{event.description}\""
    else
      missing << "Sport: #{sport}" if sport
      missing << "Level: #{level}" if level
      missing << "Gender: #{gender}" if gender
      message =  "You don't have a team setup with #{missing.to_sentence}"
    end

    return if sync

    events.build(
      start: event.dtstart,
      name: event.summary,
      location_name: event.location,
      result_type: message
    )
  end
end
