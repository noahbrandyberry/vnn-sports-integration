class CreateScheduleProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :schedule_providers do |t|
      t.string :name
      t.string :short_name
      t.string :login_url
      t.integer :supported_by_vnn
      t.boolean :has_conference
      t.boolean :has_location_name

      t.timestamps
    end
  end
end
