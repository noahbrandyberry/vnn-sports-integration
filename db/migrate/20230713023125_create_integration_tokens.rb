class CreateIntegrationTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :integration_tokens do |t|
      t.string :integration_name
      t.string :access_token
      t.string :token_type
      t.string :scope
      t.integer :expires_in

      t.timestamps
    end
  end
end
