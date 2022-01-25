json.extract! event, :id, :name, :event_type, :start, :tba, :result_type, :conference, :scrimmage, :location_verified, :canceled, :postponed, :location, :team_results, :created_at, :updated_at
json.opponents event.opponents @team
json.home event.host_team === @team
json.result
json.result_status event.result_status @team