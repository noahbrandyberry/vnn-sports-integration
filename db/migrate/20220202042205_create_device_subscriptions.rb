class CreateDeviceSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :device_subscriptions do |t|
      t.references :device, null: false, foreign_key: true
      t.references :subscribable, polymorphic: true

      t.timestamps
    end
  end
end
