class Player < ApplicationRecord
  belongs_to :team

  def to_s
    "#{first_name} #{last_name}"
  end

  def height_humanized
    divmod_output = height.to_i.divmod(12)
    "#{divmod_output[0]}' #{divmod_output[1]}\""
  end
end
