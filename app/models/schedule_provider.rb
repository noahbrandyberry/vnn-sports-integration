class ScheduleProvider < ApplicationRecord
  has_many :schedule_sources

  def self.find_or_create_from_api result
    schedule_provider = find_by id: result['id']
    if !schedule_provider
      schedule_provider = new do |key|
        key.id = result['id']
        key.name = result['name']
        key.short_name = result['short_name']
        key.login_url = result['login_url']
        key.supported_by_vnn = result['supported_by_vnn']
        key.has_conference = result['has_conference']
        key.has_location_name = result['has_location_name']
      end

      schedule_provider.save
    end
    
    schedule_provider
  end
end
