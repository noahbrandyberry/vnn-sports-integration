class IntegrationToken < ApplicationRecord
  def expiration_date
    created_at + expires_in.seconds
  end

  def is_valid?
    expiration_date.future?
  end

  def self.latest_token integration_name
    self.where(integration_name: integration_name).last
  end

  def self.latest_valid_token integration_name
    token = latest_token integration_name
    return token.access_token if token.try(:is_valid?)
  end
end
