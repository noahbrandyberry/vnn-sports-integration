base_url = 'https://connect.vnnsports.net'
url = "#{base_url}/school/2136/teams?current_year=true&valid=true&per_page=100"
conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
  faraday.response :json
end

team_results = conn.get.body['_embedded']['team']

team_results.each do |result|
  School.find_or_create_from_api result['_embedded']['school'][0] # Create school from team data to ensure location data is passed.
  
  team = Team.find_or_create_from_api result

  if team.valid?
    puts "Saved team: #{team.name}"

    url = "#{base_url}/vnn/team/#{team.id}/event?per_page=250"
    conn = Faraday.new(url: url) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.response :json
    end

    conn.headers['Authorization'] = 'Bearer 3ce911564c2a18041053c0fcfe5c481018a31ec7'

    event_results = conn.get.body['_embedded']['event'] if conn.get.body['_embedded']
    if event_results
      event_results.each do |event_result|
        event = Event.find_or_create_from_api event_result
        puts "Failed to save event: #{event.name}\n\tErrors: #{event.errors.full_messages.to_sentence}" if !event.valid?
      end
    end
  else
    puts "Failed to save team: #{team.name}\n\tErrors: #{team.errors.full_messages.to_sentence}"
  end
end

