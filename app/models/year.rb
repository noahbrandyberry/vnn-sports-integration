class Year < ApplicationRecord
  has_many :teams

  def self.current
    Year.all.find {|year| DateTime.now.between? year.start, year.end}
  end

  def self.find_or_create_from_api result
    year = find_by id: result['id']
    if !year
      year = new do |key|
        key.id = result['id']
        key.name = result['name']
        key.start = result['start']
        key.end = result['end']
      end

      year.save
    end
    
    year
  end

  def to_s
    name
  end
end
