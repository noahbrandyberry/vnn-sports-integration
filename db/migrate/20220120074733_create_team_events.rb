class CreateTeamEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :team_events do |t|
      t.references :event, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.text :private_notes
      t.text :public_notes
      t.datetime :bus_dismissal_datetime_local
      t.datetime :bus_departure_datetime_local
      t.datetime :bus_return_datetime_local
      t.boolean :home

      t.timestamps
    end
  end
end
