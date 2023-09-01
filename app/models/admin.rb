class Admin < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, 
         :confirmable, :timeoutable, :trackable
  has_and_belongs_to_many :schools

  def name
    "#{first_name} #{last_name}"
  end
end
