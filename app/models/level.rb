class Level < ApplicationRecord
  has_many :teams

  def self.find_or_create_from_api(result)
    level = find_by id: result["id"]
    unless level
      level = new do |key|
        key.id = result["id"]
        key.name = result["name"]
      end

      level.save
    end

    level
  end

  def to_s
    name
  end

  def abbreviations
    abbs = [name]
    case name
    when "Varsity"
      abbs << "V"
    when "Junior Varsity"
      abbs << "JV"
    when "Middle School"
      abbs << "Junior High"
      abbs << "Jr High"
      abbs << "Jr. High"
      abbs << "JH"
      abbs << "MS"
    end

    abbs
  end
end
