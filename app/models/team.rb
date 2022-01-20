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
  has_many :events, through: :team_events

  def self.find_or_create_from_api result
    team = find_by id: result['id']
    if !team
      team = new do |key|
        key.id = result['id']
        key.name = result['name']
        key.label = result['label']
        key.photo_url = result['photo_url']
        key.home_description = result['home_description']
        key.hide_gender = result['hide_gender']
        key.program = Program.find_or_create_from_api result['_embedded']['program'][0] if result['_embedded'].try(:[], 'program')
        key.schedule_source = ScheduleSource.find_or_create_from_api result['_embedded']['schedule_source'][0] if result['_embedded'].try(:[], 'schedule_source')
        key.year = Year.find_or_create_from_api result['_embedded']['year'][0] if result['_embedded'].try(:[], 'year')
        key.season = Season.find_or_create_from_api result['_embedded']['season'][0] if result['_embedded'].try(:[], 'season')
        key.level = Level.find_or_create_from_api result['_embedded']['level'][0] if result['_embedded'].try(:[], 'level')
        key.school = School.find_or_create_from_api result['_embedded']['school'][0] if result['_embedded'].try(:[], 'school')
        key.gender = Gender.find_or_create_from_api result['_embedded']['gender'][0] if result['_embedded'].try(:[], 'gender')
        key.sport = Sport.find_or_create_from_api result['_embedded']['sport'][0] if result['_embedded'].try(:[], 'sport')
      end

      team.save
    end
    
    team
  end
end
