class AddSocialMediaLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :schools, :twitter_url, :string
    add_column :schools, :facebook_url, :string
    rename_column :schools, :instagram, :instagram_url
  end
end
