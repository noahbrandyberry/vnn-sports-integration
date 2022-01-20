class Team < ApplicationRecord
  belongs_to :program
  belongs_to :schedule_source
  belongs_to :year
  belongs_to :season
  belongs_to :level
  has_one :school, through: :program
  has_one :gender, through: :program
  has_one :sport, through: :program
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
        key.program = Program.find_or_create_from_api result['_embedded']['program'][0]
        key.schedule_source = ScheduleSource.find_or_create_from_api result['_embedded']['schedule_source'][0] if result['_embedded']['schedule_source']
        key.year = Year.find_or_create_from_api result['_embedded']['year'][0]
        key.season = Season.find_or_create_from_api result['_embedded']['season'][0]
        key.level = Level.find_or_create_from_api result['_embedded']['level'][0]
      end

      team.save
    end
    
    team
  end
end
