class MakeSubscribableIdString < ActiveRecord::Migration[7.0]
  def change
    change_column :device_subscriptions, :subscribable_id, :string
  end
end
