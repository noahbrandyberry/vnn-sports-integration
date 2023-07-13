class Level < ApplicationRecord
  has_many :teams

  def self.find_or_create_from_api result
    level = find_by id: result['id']
    if !level
      level = new do |key|
        key.id = result['id']
        key.name = result['name']
      end

      level.save
    end
    
    level
  end

  def to_s
    name
  end
end
