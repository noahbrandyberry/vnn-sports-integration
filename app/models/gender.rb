class Gender < ApplicationRecord
  has_many :programs
  
  def self.find_or_create_from_api result
    gender = find_by id: result['id']
    if !gender
      gender = new do |key|
        key.id = result['id']
        key.name = result['name']
      end

      gender.save
    end
    
    gender
  end
end
