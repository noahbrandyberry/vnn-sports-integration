class Season < ApplicationRecord
  has_many :teams

  def self.find_or_create_from_api result
    season = find_by id: result['id']
    if !season
      season = new do |key|
        key.id = result['id']
        key.name = result['name']
        key.start = result['start']['date']
        key.end = result['end']['date']
      end

      season.save
    end
    
    season
  end

  def to_s
    name
  end
end
