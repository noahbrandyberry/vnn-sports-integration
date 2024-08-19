class RemoveYearDefaultFromImportSources < ActiveRecord::Migration[7.0]
  def change
    change_column_default :import_sources, :year_id, nil
  end
end
