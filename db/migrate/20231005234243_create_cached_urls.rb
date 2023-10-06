class CreateCachedUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :cached_urls do |t|
      t.string :url
      t.json :response

      t.timestamps
    end
  end
end
