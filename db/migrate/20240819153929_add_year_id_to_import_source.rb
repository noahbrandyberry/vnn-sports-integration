class AddYearIdToImportSource < ActiveRecord::Migration[7.0]
  def change
    add_reference :import_sources, :year, null: false, foreign_key: true, default: Year.last.id
  end
end
