class CreateYears < ActiveRecord::Migration[7.0]
  def change
    create_table :years do |t|
      t.string :name
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end
end
