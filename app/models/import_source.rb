class ImportSource < ApplicationRecord
  belongs_to :school
  belongs_to :sport, optional: true
  belongs_to :gender, optional: true
  belongs_to :level, optional: true
  has_many :events, dependent: :destroy

  def fetch_calendar
    client = Faraday.new(url: url) do |client|
      client.request :url_encoded
      client.adapter Faraday.default_adapter
    end
    response = client.get.body

    calendar = Icalendar::Calendar.parse(response).first
    
    calendar_name = calendar.custom_properties['name'].try(:first)
    self.name = calendar_name if calendar_name
    calendar
  end

  def possible_teams
    teams = school.teams.includes(:level, :sport, :gender).where(year: Year.last)
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
    self.events.destroy_all
    teams = possible_teams
    fetch_calendar.events.each do |event| 
      add_event event, teams, true
    end
    save
  end

  def add_event event, teams, sync = false
    description = event.description || ''
    if level && sport && gender
      team = teams.first
      self.events.build(
        start: event.dtstart, 
        name: event.summary,
        location_name: event.location,
        team_events: [
          team.team_events.build(opponent_name: event.summary)
        ]
      )
    else
      event_length = self.events.length

      teams.each do |team|
        unless level
          abbreviation = team.level.abbreviations.find{ |a| description.match(/\b#{a}\b/) }
          if abbreviation
            start = event.dtstart.in_time_zone(school.timezone)
            time = description.match(/\b#{abbreviation}\b - ([\d]{1,2}:[\d]{2})\b/).try(:[], 1)
            if time
              hours = time.split(":")[0].to_i
              minutes = time.split(":")[1].to_i
              hours += 12 if start.strftime('%P') == 'pm'
              start = start.change({hour: hours, min: minutes})
            end

            short = event.location.length < 5

            location_search = short && school.location ? "#{event.location} #{school.location.city}" : event.location
            location_results = location_search.present? ? Geocoder.search(name: location_search) : []
            location_result = location_results.first

            timezone = Timezone['America/New_York']

            if location_result && location_result.place_id
              location_place = Geocoder.search(location_result.place_id, lookup: :google_places_details).first
              timezone = Timezone.lookup(location_place.latitude, location_place.longitude)
              if location_place && location_place.street_address.present?
                new_location_record = Location.new(
                  name: location_place.data['name'],
                  address_1: location_place.street_address,
                  city: location_place.city,
                  state: location_place.state,
                  zip: location_place.postal_code,
                  latitude: location_place.latitude,
                  longitude: location_place.longitude,
                  timezone: timezone.name
                )
                home = school.location.distance_to(new_location_record) < 2
                (new_location_record.name = home ? school.location.name : event.summary) unless new_location_record.name
              end
            end

            self.events.build(
              start: start, 
              name: event.summary,
              location_name: event.location,
              location: new_location_record,
              team_events: [
                team.team_events.build(opponent_name: event.summary, home: home)
              ]
            )
          end
        end
      end

      if self.events.length == event_length && !sync
        self.events.build(
          start: event.dtstart, 
          name: "Not Found: #{event.summary}",
          location_name: event.location,
          team_events: [
            TeamEvent.new(public_notes: event.description)
          ]
        )
      end
    end
  end
end
