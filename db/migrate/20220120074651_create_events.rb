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
      t.boolean :canceled
      t.boolean :postponed
      t.references :location, null: true, foreign_key: true

      t.timestamps
    end
  end
end
