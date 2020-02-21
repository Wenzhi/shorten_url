FactoryBot.define do
  factory :url_mapping do
    actual_url { "https://actual_url.com" }
    token  { "token" }
  end
end
