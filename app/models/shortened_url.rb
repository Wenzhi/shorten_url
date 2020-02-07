require 'securerandom'

class ShortenedUrl < ApplicationRecord

  def generate_short_url
    short_url = SecureRandom.base64(10)
    while ShortenedUrl.where(short_url: short_url).first
      short_url = SecureRandom.base64(10)
    end
    self.short_url = 'localhost:3000/s/' + short_url
  end
end
