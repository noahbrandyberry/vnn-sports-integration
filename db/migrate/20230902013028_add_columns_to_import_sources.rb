class AddColumnsToImportSources < ActiveRecord::Migration[7.0]
  def change
    add_column :import_sources, :last_import_time, :datetime
    add_column :import_sources, :frequency_hours, :integer, null: false, default: 24
  end
end
