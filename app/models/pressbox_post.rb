class PressboxPost < ApplicationRecord
  self.primary_key = :id

  belongs_to :event, optional: true
  belongs_to :team

  def self.find_or_create_from_api result
    pressbox_post = find_by id: result['id']
    if !pressbox_post
      pressbox_post = new do |key|
        key.id = result['id']
        key.title = result['title']
        key.recap = result['recap']
        key.featured_image = result['featured_image']
        key.boxscore = result['boxscore']
        key.is_visible = result['is_visible']
        key.website_only = result['website_only']
        key.created = result['created']
        key.modified = result['modified']
        key.submitted = result['submitted']
        key.created_by = "#{result['created_by']['name']['first']} #{result['created_by']['name']['last']}"
        key.modified_by = "#{result['modified_by']['name']['first']} #{result['modified_by']['name']['last']}"
        key.submitted_by = "#{result['submitted_by']['name']['first']} #{result['submitted_by']['name']['last']}"
        key.event = Event.find_or_create_from_api result['_embedded']['event'][0] if result['_embedded']['event']
        key.team = Team.find_or_create_from_api result['_embedded']['team'][0] if result['_embedded']['team']
      end

      pressbox_post.save
    end
    
    pressbox_post
  end
end
