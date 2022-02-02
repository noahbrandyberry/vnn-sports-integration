class DeviceSubscription < ApplicationRecord
  belongs_to :device
  belongs_to :subscribable, polymorphic: true
end
