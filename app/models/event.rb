class Event < ApplicationRecord
  belongs_to :location, optional: true
  has_many :team_events, dependent: :destroy
  has_many :teams, through: :team_events
  has_many :pressbox_posts
  has_many :team_results
  has_one :result
  belongs_to :import_source, optional: true

  scope :upcoming, -> { where(start: Time.now..) }
  scope :past, -> { where(start: ..Time.now) }

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
  
  def self.update_or_create_from_api result
    event = find_by id: "vnn-#{result['id']}"

    if event
      team_events = []

      event = event.tap do |key|
        key.id = "vnn-#{result['id']}"
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
        team_events << TeamEvent.update_or_create_from_api(result, event, Team.find_or_create_from_api(result['_embedded']['team'][0]))

        if result['_embedded']['opponent']
          result['_embedded']['opponent'].each do |opponent|
            url = opponent["_links"]["self"]["href"]

            unless url.include? "opponent"
              fetched_opponent = Vnn::V1::Client.authorized_request(
                http_method: :get, 
                endpoint: url
              )
            end

            if opponent['_embedded'].try(:[], 'team') && !opponent['_embedded']['team'][0].try(:[], 'invalid')
              team_events << TeamEvent.update_or_create_from_api({'_embedded' => result['_embedded']}, event, Team.find_or_create_from_api(fetched_opponent))
            end
          end
        end

        event.team_events.where.not(id: team_events.map(&:id)).destroy_all

        if result['result'].kind_of?(Array)
          event.team_results.destroy_all
          result['result'].each do |result|
            result = result['team']
            TeamResult.create(event: event, team_id: "vnn-#{result['id']}", name: result['name'], place: result['place'], points: result['points'])
          end
        elsif result['result'] && result['result']['away'] && result['result']['home']
          event.result.try(:destroy)
          Result.create(event: event, away: result['result']['away'], home: result['result']['home'])
        end
      end
    else
      event = self.create_from_api result
    end
    
    event
  end

  def self.find_or_create_from_api result
    event = find_by id: "vnn-#{result['id']}"
    event = self.create_from_api result if !event
    
    event
  end
  
  def self.create_from_api result
    event = new do |key|
      key.id = "vnn-#{result['id']}"
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
      TeamEvent.update_or_create_from_api(result, event, Team.find_or_create_from_api(result['_embedded']['team'][0]))

      if result['_embedded']['opponent']
        result['_embedded']['opponent'].each do |opponent|
          url = opponent["_links"]["self"]["href"]

          unless url.include? "opponent"
            fetched_opponent = Vnn::V1::Client.authorized_request(
              http_method: :get, 
              endpoint: url
            )
          end

          if opponent['_embedded'].try(:[], 'team') && !opponent['_embedded']['team'][0].try(:[], 'invalid')
            TeamEvent.update_or_create_from_api({'_embedded' => result['_embedded']}, event, Team.find_or_create_from_api(fetched_opponent))
          end
        end
      end

      if result['result'].kind_of?(Array)
        result['result'].each do |result|
          result = result['team']
          TeamResult.create(event: event, team_id: "vnn-#{result['id']}", name: result['name'], place: result['place'], points: result['points'])
        end
      elsif result['result'] && result['result']['away'] && result['result']['home']
        Result.create(event: event, away: result['result']['away'], home: result['result']['home'])
      end
    end
      
    event
  end

  def host_team
    team_events.select{|team_event| team_event.home}.first.try :team
  end
end
