class School < ApplicationRecord
  belongs_to :location, optional: true
  has_many :programs
  has_many :teams
  has_many :device_subscriptions, as: :subscribable

  def all_teams
    (teams + programs.map(&:teams)).flatten.uniq
  end

  def current_teams
    current_year = Year.current
    seasons = Season.all.select do |season|
      start_year = season.start.month >= current_year.start.month ? current_year.start.year : current_year.end.year
      start_date = season.start.change(year: start_year)

      end_year = season.end.month >= current_year.start.month ? current_year.start.year : current_year.end.year
      end_date = season.end.change(year: end_year)

      DateTime.now.between? start_date, end_date
    end

    Team.includes(:team_events).where(season: seasons, school_id: id).or(Team.includes(:team_events).where(season: seasons, program: programs))
  end

  def self.update_or_create_from_api result
    school = find_by id: "vnn-#{result['id']}"

    if school
      school = school.tap do |key|
        key.id = "vnn-#{result['id']}"
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
        key.visible = true
      end

      school.save
    else
      school = self.create_from_api result, true
    end

    school
  end

  def self.find_or_create_from_api result
    school = find_by id: "vnn-#{result['id']}"
    school = self.create_from_api result if !school
    
    school
  end
  
  def self.create_from_api result, visible = false
    school = new do |key|
      key.id = "vnn-#{result['id']}"
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
      key.visible = visible
    end

    school.save
    school
  end

  def self.import_by_school_id school_id
    team_results = Vnn::V1::Client.authorized_request(
      http_method: :get, 
      endpoint: "school/#{school_id}/teams?current_year=true&valid=true&per_page=100"
    )['_embedded']['team']

    team_results.each do |result|
      self.update_or_create_from_api result['_embedded']['school'][0] # Create school from team data to ensure location data is passed.
      
      team = Team.update_or_create_from_api result

      if team.valid?
        puts "Saved team: #{team.school.try(:name)} - #{team.name}"

        event_results_response = Vnn::V1::Client.authorized_request(
          http_method: :get, 
          endpoint: "vnn/team/#{result['id']}/event?per_page=250&visible=true"
        )
        event_results = event_results_response['_embedded']['event'] if event_results_response['_embedded']

        if event_results
          event_results.each do |event_result|
            event = Event.update_or_create_from_api event_result
            puts "Failed to save event: #{event.name}\n\tErrors: #{event.errors.full_messages.to_sentence}" if !event.valid?
          end
        end

        posts_response = Vnn::V1::Client.authorized_request(
          http_method: :get, 
          endpoint: "team/#{result['id']}/pressbox/post"
        )

        posts = posts_response['_embedded']['pressbox_post'] if posts_response['_embedded']
        
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
