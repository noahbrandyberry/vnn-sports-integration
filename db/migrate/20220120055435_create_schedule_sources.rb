class CreateScheduleSources < ActiveRecord::Migration[7.0]
  def change
    create_table :schedule_sources do |t|
      t.string :url
      t.datetime :last_update
      t.datetime :last_sync_request
      t.references :schedule_provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
