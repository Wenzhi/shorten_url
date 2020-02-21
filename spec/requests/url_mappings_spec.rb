require 'rails_helper'

RSpec.describe 'url_mappings' do
  describe 'POST /url_mappings.json' do
    let(:url_mapping) { create(:url_mapping) }

    it 'return exist shortened url for exist actual url' do
      post '/url_mappings/', :params => { :actual_url => url_mapping.actual_url, :format => :json }
      expect(JSON.parse(response.body)['token']).to eq(url_mapping.token)
      expect(JSON.parse(response.body)['shortened_url']).to eq(request.host_with_port+url_mapping_path(url_mapping.token))
    end

    it 'create new shortened url for new actual url' do
      post '/url_mappings/', :params => { :actual_url => 'https://www.truecoach.co', :format => :json }
      token = JSON.parse(response.body)['token']
      expect(token).not_to be_nil
      expect(token).not_to eq(url_mapping.token)
      expect(JSON.parse(response.body)['shortened_url']).to eq(request.host_with_port+url_mapping_path(token))
    end
  end

  describe 'GET /url_mappings/:token.html with an existing token' do
    let(:url_mapping) { create(:url_mapping) }
    let(:get_request) { get(url_mapping_path(token: url_mapping.token, format: :html)) }

    it 'get url mapping in html to redirect' do
      # binding.pry
      expect(get_request).to redirect_to(url_mapping.actual_url)
    end
  end

  describe 'GET /url_mappings/:token.json with an existing token' do
    let(:url_mapping) { create(:url_mapping) }

    it 'get shortened url in json' do
      get(url_mapping_path(token: url_mapping.token, format: :json))
      expect(JSON.parse(response.body)['token']).to eq(url_mapping.token)
      expect(JSON.parse(response.body)['actual_url']).to eq(url_mapping.actual_url)
      expect(JSON.parse(response.body)['shortened_url']).to eq(request.host_with_port+url_mapping_path(url_mapping.token))
    end
  end

  # describe 'GET /url_mappings/:token.html with a non-exist token' do
  #   let(:get_request) { get(url_mapping_path(token: "non exist token", format: :html)) }
  #
  #   it 'get url mapping in html to redirect' do
  #     expect(JSON.parse(response.body)['error_message']).to eq("Cannot find the corresponding actual url.")
  #   end
  # end

  describe 'GET /url_mappings/:token.json with a non-exist token' do
    it 'get shortened url in json' do
      get(url_mapping_path(token: "non exist token", format: :json))
      expect(JSON.parse(response.body)['error_message']).to eq("Cannot find the corresponding actual url.")
    end
  end
end
