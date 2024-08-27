json.array! @events do |team, event|
  json.partial! "api/v1/events/event", event: event, school_id: team.school_id, team: team
end
