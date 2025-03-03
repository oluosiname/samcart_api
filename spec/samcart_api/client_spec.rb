# frozen_string_literal: true

require 'spec_helper'
require 'samcart_api'

RSpec.describe SamcartApi::Client do
  let(:api_key) { 'test_api_key' }
  let(:client) { described_class.new(api_key) }

  before do
    SamcartApi.configure do |config|
      config.api_key = api_key
      config.api_url = 'https://api.samcart.com/v1'
    end
  end

  describe '#initialize' do
    it 'raises error when no API key is provided' do
      SamcartApi.configuration.api_key = nil
      expect { described_class.new }.to raise_error(SamcartApi::ConfigurationError)
    end

    it 'uses provided API key' do
      expect(client.instance_variable_get(:@api_key)).to eq(api_key)
    end
  end

  describe 'HTTP methods' do
    before do
      allow(SamcartApi::ApiRequest).to receive(:new).and_return(
        instance_double(SamcartApi::ApiRequest, perform: { 'data' => 'success' }),
      )
    end

    describe '#get' do
      it 'retrieves data from the API' do
        response = client.get('/test')
        expect(response).to eq({ 'data' => 'success' })
      end
    end

    describe '#post' do
      it 'creates a resource via the API' do
        response = client.post('/test', { name: 'test' })
        expect(response).to eq({ 'data' => 'success' })
      end
    end

    describe '#put' do
      it 'updates a resource via the API' do
        response = client.put('/test', { name: 'updated' })
        expect(response).to eq({ 'data' => 'success' })
      end
    end

    describe '#delete' do
      it 'deletes a resource via the API' do
        response = client.delete('/test')
        expect(response).to eq({ 'data' => 'success' })
      end
    end
  end
end
