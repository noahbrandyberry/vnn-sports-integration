class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :label
      t.string :photo_url
      t.text :home_description
      t.boolean :hide_gender
      t.references :program, null: false, foreign_key: true
      t.references :schedule_source, null: true, foreign_key: true
      t.references :year, null: false, foreign_key: true
      t.references :season, null: false, foreign_key: true
      t.references :level, null: false, foreign_key: true

      t.timestamps
    end
  end
end
