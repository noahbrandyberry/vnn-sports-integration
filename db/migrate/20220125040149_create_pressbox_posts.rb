class CreatePressboxPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :pressbox_posts, id: false do |t|
      t.string :id, null: false
      t.boolean :is_visible
      t.datetime :created
      t.datetime :modified
      t.string :created_by
      t.string :modified_by
      t.datetime :submitted
      t.string :submitted_by
      t.string :title
      t.text :recap
      t.text :boxscore
      t.boolean :website_only
      t.string :featured_image
      t.references :event, null: true, foreign_key: true
      t.references :team, null: true, foreign_key: true

      t.timestamps
    end
  end
end
