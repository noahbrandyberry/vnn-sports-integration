class Device < ApplicationRecord
  has_many :device_subscriptions, dependent: :destroy
  accepts_nested_attributes_for :device_subscriptions, allow_destroy: true
end
