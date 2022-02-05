team = @team || @teams.to_a.intersection(event.teams).first

json.extract! event, :id, :name, :event_type, :start, :tba, :result_type, :conference, :scrimmage, :location_verified, :canceled, :postponed, :location, :result, :created_at, :updated_at
json.opponents event.opponents team
json.home event.host_team === team
json.result_status event.result_status team
json.opponent_name event.team_events.to_a.find { |team_event| team_event.team_id === team.id }.try(:opponent_name)
json.team_results event.team_results do |team_result|
  json.extract! team_result, :id, :team_id, :name, :place, :points, :team_id, :event_id
  json.school_id team_result.team.school_id
end
json.selected_team_id team.id