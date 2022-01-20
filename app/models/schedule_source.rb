class ScheduleSource < ApplicationRecord
  belongs_to :schedule_provider
  has_many :teams

  def self.find_or_create_from_api result
    schedule_source = find_by id: result['id']
    if !schedule_source
      schedule_source = new do |key|
        key.id = result['id']
        key.url = result['url']
        key.last_update = result['last_update']
        key.last_sync_request = result['last_sync_request']
        key.schedule_provider = ScheduleProvider.find_or_create_from_api result['_embedded']['schedule_provider'][0]
      end

      schedule_source.save
    end
    
    schedule_source
  end
end
