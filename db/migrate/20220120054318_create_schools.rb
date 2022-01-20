class CreateSchools < ActiveRecord::Migration[7.0]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :mascot
      t.boolean :is_vnn
      t.string :url
      t.string :logo_url
      t.text :anti_discrimination_disclaimer
      t.text :registration_text
      t.string :registration_url
      t.string :primary_color
      t.string :secondary_color
      t.string :tertiary_color
      t.integer :enrollment
      t.string :athletic_director
      t.string :phone
      t.string :email
      t.integer :blog
      t.integer :sportshub_version
      t.integer :version
      t.string :instagram
      t.string :onboarding
      t.references :location, null: true, foreign_key: true

      t.timestamps
    end
  end
end
