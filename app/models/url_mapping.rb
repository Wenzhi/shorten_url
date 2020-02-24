require 'securerandom'

class UrlMapping < ApplicationRecord
  before_create :generate_token

  def generate_token
    token = SecureRandom.base64(10)
    while UrlMapping.where(token: token).first
      token = SecureRandom.base64(10)
    end
    self.token = token
  end
end
