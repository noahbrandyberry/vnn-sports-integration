class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :grad_year
      t.string :jersey
      t.string :position
      t.string :height
      t.string :weight
      t.references :team, null: true, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
