class School < ApplicationRecord
  belongs_to :location, optional: true
  has_many :programs
  has_many :teams
  
  def self.find_or_create_from_api result
    school = find_by id: result['id']
    if !school
      conn = Faraday.new(url: result["_links"]["self"]["href"]) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.response :json
      end

      result = conn.get.body

      school = new do |key|
        key.id = result['id']
        key.name = result['name']
        key.mascot = result['mascot']
        key.is_vnn = result['is_vnn']
        key.url = result['url']
        key.logo_url = result['logo_url']
        key.anti_discrimination_disclaimer = result['anti_discrimination_disclaimer']
        key.registration_text = result['registration_text']
        key.registration_url = result['registration_url']
        key.primary_color = result['primary_color']
        key.secondary_color = result['secondary_color']
        key.tertiary_color = result['tertiary_color']
        key.enrollment = result['enrollment']
        key.athletic_director = result['athletic_director']
        key.phone = result['phone']
        key.email = result['email']
        key.blog = result['blog']
        key.sportshub_version = result['sportshub_version']
        key.version = result['version']
        key.instagram = result['instagram']
        key.onboarding = result['onboarding']
        key.location = Location.find_or_create_from_api result['_embedded']['location'][0] if result['_embedded'].try(:[], 'location')
      end

      school.save
    end
    
    school
  end

  def self.import_by_school_id school_id
    base_url = 'https://connect.vnnsports.net'
    url = "#{base_url}/school/#{school_id}/teams?current_year=true&valid=true&per_page=100"
    conn = Faraday.new(url: url) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.response :json
    end

    team_results = conn.get.body['_embedded']['team']

    team_results.each do |result|
      self.find_or_create_from_api result['_embedded']['school'][0] # Create school from team data to ensure location data is passed.
      
      team = Team.find_or_create_from_api result

      if team.valid?
        puts "Saved team: #{team.name}"

        url = "#{base_url}/vnn/team/#{team.id}/event?per_page=250&visible=true"
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
        url = "#{base_url}/team/#{team.id}/pressbox/post"
        conn = Faraday.new(url: url) do |faraday|
          faraday.adapter Faraday.default_adapter
          faraday.response :json
        end

        conn.headers['Authorization'] = 'Bearer 3ce911564c2a18041053c0fcfe5c481018a31ec7'

        posts = conn.get.body['_embedded']['pressbox_post'] if conn.get.body['_embedded']
        if posts
          posts.each do |post|
            pressbox_post = PressboxPost.find_or_create_from_api post
            puts "Failed to save pressbox_post: #{pressbox_post.title}\n\tErrors: #{pressbox_post.errors.full_messages.to_sentence}" if !pressbox_post.valid?
          end
        end
      else
        puts "Failed to save team: #{team.name}\n\tErrors: #{team.errors.full_messages.to_sentence}"
      end
    end
  end
end
