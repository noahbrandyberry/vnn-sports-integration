class Sport < ApplicationRecord
  has_many :programs
  has_many :teams

  def self.find_or_create_from_api result
    sport = find_by id: result['id']
    if !sport
      sport = new do |key|
        key.id = result['id']
        key.name = result['name']
      end

      sport.save
    end
    
    sport
  end

  def to_s
    name
  end
end
