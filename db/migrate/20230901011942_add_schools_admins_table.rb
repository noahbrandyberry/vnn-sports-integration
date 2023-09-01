class AddSchoolsAdminsTable < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :first_name, :string
    add_column :admins, :last_name, :string

    create_table :admins_schools, id: false do |t|
      t.belongs_to :school, type: :string
      t.belongs_to :admin
    end
  end
end
