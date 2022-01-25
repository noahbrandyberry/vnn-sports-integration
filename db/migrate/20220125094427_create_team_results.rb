class CreateTeamResults < ActiveRecord::Migration[7.0]
  def change
    create_table :team_results do |t|
      t.references :team, null: true, foreign_key: true
      t.string :name
      t.integer :place
      t.integer :points
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
