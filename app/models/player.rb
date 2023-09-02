class Player < ApplicationRecord
  belongs_to :team

  def to_s
    "#{first_name} #{last_name}"
  end
end
