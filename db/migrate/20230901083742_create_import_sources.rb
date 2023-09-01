class CreateImportSources < ActiveRecord::Migration[7.0]
  def change
    create_table :import_sources do |t|
      t.string :name
      t.string :url
      t.references :school, null: false, foreign_key: true, type: :string
      t.references :sport, null: true, foreign_key: true
      t.references :gender, null: true, foreign_key: true
      t.references :level, null: true, foreign_key: true

      t.timestamps
    end

    add_reference :events, :import_source, null: true, foreign_key: true
  end
end
