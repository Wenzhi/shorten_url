FactoryBot.define do
  factory :shortened_url do
    actual_url { "https://actual_url.com" }
    short_url  { "localhost:3000/s/shortened" }
  end
end
