class Location < ApplicationRecord
  has_many :events
  has_many :schools
  
  def self.find_or_create_from_api result
    location = find_by id: result['id']
    if !location
      location = new do |key|
        key.id = result['id']
        key.name = result['name']
        key.address_1 = result['address_1']
        key.address_2 = result['address_2']
        key.state = result['state']['name']
        key.zip = result['zip']
        key.plus_4 = result['plus_4']
        key.timezone = result['timezone']
        key.latitude = result['latitude']
        key.longitude = result['longitude']
      end

      location.save
    end
    
    location
  end
end
