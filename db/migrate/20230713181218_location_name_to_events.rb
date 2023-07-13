class LocationNameToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :location_name, :string
  end
end
