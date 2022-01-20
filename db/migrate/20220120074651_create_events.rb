class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :event_type
      t.datetime :start
      t.boolean :tba
      t.string :result_type
      t.boolean :conference
      t.boolean :scrimmage
      t.boolean :location_verified
      t.text :private_notes
      t.text :public_notes
      t.datetime :bus_dismissal_datetime_local
      t.datetime :bus_departure_datetime_local
      t.datetime :bus_return_datetime_local
      t.boolean :home
      t.boolean :canceled
      t.boolean :postponed
      t.references :location, null: true, foreign_key: true
      t.references :host_team, null: true, foreign_key: { to_table: :teams }

      t.timestamps
    end
  end
end
