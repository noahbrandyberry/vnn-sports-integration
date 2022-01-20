class Event < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :host_team, class_name: "Team", optional: true
  has_many :team_events
  has_many :teams, through: :team_events

  def self.find_or_create_from_api result
    event = find_by id: result['id']
    if !event
      event = new do |key|
        key.id = result['id']
        key.name = result['name']
        key.event_type = result['event_type']
        key.start = result['start']
        key.tba = result['tba']
        key.result_type = result['result_type']
        key.conference = result['conference']
        key.scrimmage = result['scrimmage']
        key.location_verified = result['location_verified']
        key.private_notes = result['private_notes']
        key.public_notes = result['public_notes']
        key.bus_dismissal_datetime_local = result['bus_dismissal_datetime_local']
        key.bus_departure_datetime_local = result['bus_departure_datetime_local']
        key.bus_return_datetime_local = result['bus_return_datetime_local']
        key.home = result['home']
        key.canceled = result['canceled']
        key.postponed = result['postponed']
        key.host_team = Team.find_or_create_from_api result['_embedded']['host_team'][0] if result['_embedded']['host_team']
        key.location = Location.find_or_create_from_api result['_embedded']['location'][0] if result['_embedded']['location']
      end

      if event.save
        team_event = TeamEvent.new do |key|
          key.event = event
          key.team = Team.find_or_create_from_api result['_embedded']['team'][0]
        end

        if result['_embedded']['opponents']
          result['_embedded']['opponents'].each do |opponent|
            team_event = TeamEvent.new do |key|
              key.event = event
              key.team = Team.find_or_create_from_api opponent
            end
          end
        end

        team_event.save
      end
    end
    
    event
  end
end
