class Event < ApplicationRecord
  belongs_to :location, optional: true
  has_many :team_events
  has_many :teams, through: :team_events
  has_many :pressbox_posts
  has_many :team_results
  has_one :result

  def result_status team
    is_home_team = host_team === team
    if result
      if result.home > result.away
        return is_home_team ? 'win' : 'loss'
      elsif result.away > result.home
        return is_home_team ? 'loss' : 'win'
      else
        return 'tie'
      end
    end
  end

  def opponents team
    teams.select {|t| t.id != team.id}
  end

  def self.find_or_create_from_api result
    event = find_by id: result['id']
    if !event
      host_team = result['_embedded']['host_team'][0] if result['_embedded']['host_team']
      host_team_id = host_team.try(:[], 'id')

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
        key.canceled = result['canceled']
        key.postponed = result['postponed']
        key.location = Location.find_or_create_from_api result['_embedded']['location'][0] if result['_embedded']['location']
      end

      if event.save
        team_event = TeamEvent.new do |key|
          key.event = event
          key.team = Team.find_or_create_from_api result['_embedded']['team'][0]
          key.private_notes = result['private_notes']
          key.public_notes = result['public_notes']
          key.bus_dismissal_datetime_local = result['bus_dismissal_datetime_local']
          key.bus_departure_datetime_local = result['bus_departure_datetime_local']
          key.bus_return_datetime_local = result['bus_return_datetime_local']
          key.home = (result['home'] || host_team_id == key.team.id)
          key.opponent_name = result['opponent_name']
        end
        team_event.save

        if result['_embedded']['opponent']
          result['_embedded']['opponent'].each do |opponent|
            url = opponent["_links"]["self"]["href"]

            unless url.include? "opponent"
              conn = Faraday.new(url: url) do |faraday|
                faraday.adapter Faraday.default_adapter
                faraday.response :json
              end

              fetched_opponent = conn.get.body
            end

            if opponent['_embedded'].try(:[], 'team') && !opponent['_embedded']['team'][0].try(:[], 'invalid')
              team_event = TeamEvent.new do |key|
                key.event = event
                key.team = Team.find_or_create_from_api fetched_opponent
                key.home = host_team_id == key.team.id
              end

              team_event.save
            end
          end
        end

        if result['result'].kind_of?(Array)
          result['result'].each do |result|
            result = result['team']
            TeamResult.create(event: event, team_id: result['id'], name: result['name'], place: result['place'], points: result['points'])
          end
        elsif result['result'] && result['result']['away'] && result['result']['home']
          Result.create(event: event, away: result['result']['away'], home: result['result']['home'])
        end
      end
    end
    
    event
  end

  def host_team
    team_events.select{|team_event| team_event.home}.first.try :team
  end
end
