class CreateTeamEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :team_events do |t|
      t.references :event, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
