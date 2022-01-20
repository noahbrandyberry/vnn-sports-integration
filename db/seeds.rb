base_url = 'https://connect.vnnsports.net'
url = "#{base_url}/school/2136/teams?current_year=true&valid=true&per_page=100"
conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
  faraday.response :json
end

team_results = conn.get.body['_embedded']['team']

team_results.each do |result|
  team = Team.find_or_create_from_api result

  if team.valid?
    puts "Saved team: #{team.name}"

    url = "#{base_url}/vnn/team/#{team.id}/event/?per_page=250"
    conn = Faraday.new(url: url) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.response :json
    end

    event_results = conn.get.body['_embedded']['event']
    event_results.each do |event|
      TeamEvent.find_or_create_from_api event
    end
  else
    puts "Failed to save team: #{team.name}"
  end
end

