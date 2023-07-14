class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images, id: :string do |t|
      t.string :url
      t.string :description
      t.references :team, null: false, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
