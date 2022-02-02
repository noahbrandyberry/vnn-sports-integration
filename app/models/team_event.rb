class TeamEvent < ApplicationRecord
  belongs_to :event
  belongs_to :team

  def self.update_or_create_from_api result, event, team
    host_team = result['_embedded']['host_team'][0] if result['_embedded']['host_team']
    host_team_id = host_team.try(:[], 'id')

    team_event = find_by event_id: event.id, team_id: team.id
    team_event = new if !team_event

    team_event = team_event.tap do |key|
      key.event = event
      key.team = team
      key.private_notes = result['private_notes']
      key.public_notes = result['public_notes']
      key.bus_dismissal_datetime_local = result['bus_dismissal_datetime_local']
      key.bus_departure_datetime_local = result['bus_departure_datetime_local']
      key.bus_return_datetime_local = result['bus_return_datetime_local']
      key.home = (result['home'] || host_team_id == key.team.id)
      key.opponent_name = result['opponent_name']
    end

    team_event.save

    team_event
  end
end
