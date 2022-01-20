class Program < ApplicationRecord
  belongs_to :school
  belongs_to :gender
  belongs_to :sport
  has_many :teams

  def self.find_or_create_from_api result
    program = find_by id: result['id']
    if !program
      program = new do |key|
        key.id = result['id']
        key.name = result['name']
        key.name_slug = result['name_slug']
        key.school = School.find_or_create_from_api result['_embedded']['school'][0]
        key.gender = Gender.find_or_create_from_api result['_embedded']['gender'][0]
        key.sport = Sport.find_or_create_from_api result['_embedded']['sport'][0]
      end

      program.save
    end

    program
  end
end
