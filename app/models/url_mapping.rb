require 'securerandom'

class UrlMapping < ApplicationRecord

  def generate_token
    token = SecureRandom.base64(10)
    while UrlMapping.where(token: token).first
      token = SecureRandom.base64(10)
    end
    self.token = token
  end
end
