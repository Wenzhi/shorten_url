require 'rails_helper'

RSpec.describe 'shortened_urls_endpoints' do
  describe 'POST /shortened_urls/.json' do
    let(:shortened_url) { create(:shortened_url) }

    it 'return exist shortened url for exist actual url' do
      post '/shortened_urls/', :params => { :url => shortened_url.actual_url, :format => :json }
      expect(JSON.parse(response.body)['shortened']).to eq(shortened_url.short_url)
    end

    it 'create new shortened url for new actual url' do
      post '/shortened_urls/', :params => { :url => 'https://www.truecoach.co', :format => :json }
      shortened = JSON.parse(response.body)['shortened']
      expect(shortened).not_to be_nil
      expect(shortened).not_to eq(shortened_url.short_url)
    end
  end

  describe 'GET /shortened_urls/:id.html' do
    let(:shortened_url) { create(:shortened_url) }
    let(:get_request) { get(shortened_url_path(id: shortened_url.id, format: :html)) }

    it 'get shortened url in html' do
      expect(get_request).to redirect_to(shortened_url.short_url)
    end
  end

  describe 'GET /shortened_urls/:id.json' do
    let(:shortened_url) { create(:shortened_url) }

    it 'get shortened url in json' do
      get(shortened_url_path(id: shortened_url.id, format: :json))
      expect(JSON.parse(response.body)['shortened']).to eq(shortened_url.short_url)
      expect(JSON.parse(response.body)['actual']).to eq(shortened_url.actual_url)
    end
  end
end
