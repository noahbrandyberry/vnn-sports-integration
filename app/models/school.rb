class School < ApplicationRecord
  belongs_to :location
  has_many: programs
  
  def self.find_or_create_from_api result
    school = find_by id: result['id']
    if !school
      school = new do |key|
        key.id = result['id']
        key.name = result['name']
        key.mascot = result['mascot']
        key.is_vnn = result['is_vnn']
        key.url = result['url']
        key.logo_url = result['logo_url']
        key.anti_discrimination_disclaimer = result['anti_discrimination_disclaimer']
        key.registration_text = result['registration_text']
        key.registration_url = result['registration_url']
        key.primary_color = result['primary_color']
        key.secondary_color = result['secondary_color']
        key.tertiary_color = result['tertiary_color']
        key.enrollment = result['enrollment']
        key.athletic_director = result['athletic_director']
        key.phone = result['phone']
        key.email = result['email']
        key.blog = result['blog']
        key.sportshub_version = result['sportshub_version']
        key.version = result['version']
        key.instagram = result['instagram']
        key.onboarding = result['onboarding']
        key.location = Location.find_or_create_from_api result['_embedded']['location'][0]
      end

      school.save
    end
    
    school
  end
end
