class Team < ApplicationRecord
  belongs_to :program, optional: true
  belongs_to :schedule_source, optional: true
  belongs_to :year, optional: true
  belongs_to :season, optional: true
  belongs_to :level, optional: true
  belongs_to :school, optional: true
  belongs_to :gender, optional: true
  belongs_to :sport, optional: true

  has_many :team_events
  has_many :team_results
  has_many :events, through: :team_events
  has_many :pressbox_posts
  has_many :images
  has_many :device_subscriptions, as: :subscribable
  has_many :players

  def record
    event_results = events.select{|event| event.result}
      if event_results.length > 0
      current_record = {
        win: 0,
        loss: 0,
        tie: 0
      }
      event_results.each do |event|
        result_status = event.result_status self
        current_record[result_status.to_sym] += 1
      end

      return current_record
    end
  end

  def self.update_or_create_from_api result
    team = find_by id: "vnn-#{result['id']}"

    if team
      team = team.tap do |key|
        key.id = "vnn-#{result['id']}"
        key.name = result['name']
        key.label = result['label']
        key.photo_url = result['photo_url']
        key.home_description = result['home_description']
        key.hide_gender = result['hide_gender']
        key.school = School.update_or_create_from_api result['_embedded']['school'][0] if result['_embedded'].try(:[], 'school')
        key.schedule_source = ScheduleSource.find_or_create_from_api result['_embedded']['schedule_source'][0] if result['_embedded'].try(:[], 'schedule_source')
        key.year = Year.find_or_create_from_api result['_embedded']['year'][0] if result['_embedded'].try(:[], 'year')
        key.season = Season.find_or_create_from_api result['_embedded']['season'][0] if result['_embedded'].try(:[], 'season')
        key.level = Level.find_or_create_from_api result['_embedded']['level'][0] if result['_embedded'].try(:[], 'level')
        key.gender = Gender.find_or_create_from_api result['_embedded']['gender'][0] if result['_embedded'].try(:[], 'gender')
        key.sport = Sport.find_or_create_from_api result['_embedded']['sport'][0] if result['_embedded'].try(:[], 'sport')
        key.program = Program.find_or_create_from_api result['_embedded']['program'][0] if result['_embedded'].try(:[], 'program')
      end

      team.save
    else
      team = self.create_from_api result
    end

    team
  end

  def self.find_or_create_from_api result
    team = find_by id: "vnn-#{result['id']}"
    team = self.create_from_api result if !team
    
    team
  end

  def self.create_from_api result
    team = new do |key|
      key.id = "vnn-#{result['id']}"
      key.name = result['name']
      key.label = result['label']
      key.photo_url = result['photo_url']
      key.home_description = result['home_description']
      key.hide_gender = result['hide_gender']
      key.school = School.find_or_create_from_api result['_embedded']['school'][0] if result['_embedded'].try(:[], 'school')
      key.schedule_source = ScheduleSource.find_or_create_from_api result['_embedded']['schedule_source'][0] if result['_embedded'].try(:[], 'schedule_source')
      key.year = Year.find_or_create_from_api result['_embedded']['year'][0] if result['_embedded'].try(:[], 'year')
      key.season = Season.find_or_create_from_api result['_embedded']['season'][0] if result['_embedded'].try(:[], 'season')
      key.level = Level.find_or_create_from_api result['_embedded']['level'][0] if result['_embedded'].try(:[], 'level')
      key.gender = Gender.find_or_create_from_api result['_embedded']['gender'][0] if result['_embedded'].try(:[], 'gender')
      key.sport = Sport.find_or_create_from_api result['_embedded']['sport'][0] if result['_embedded'].try(:[], 'sport')
      key.program = Program.find_or_create_from_api result['_embedded']['program'][0] if result['_embedded'].try(:[], 'program')
    end

    team.save
    team
  end
end
