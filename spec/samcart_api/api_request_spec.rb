# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SamcartAPI::ApiRequest do
  let(:method) { :get }
  let(:path) { '/test' }
  let(:params) { { foo: 'bar' } }
  let(:api_key) { 'test_api_key' }
  let(:request) { described_class.new(method, path, params, api_key) }

  before do
    SamcartAPI.configure do |config|
      config.api_url = 'https://api.samcart.com/v1'
    end
  end

  describe '#perform' do
    let(:connection) { instance_double(Faraday::Connection) }
    let(:response) { instance_double(Faraday::Response) }

    before do
      allow(Faraday).to receive(:new).and_return(connection)
      allow(connection).to receive(:send).and_return(response)
    end

    context 'when request is successful' do
      before do
        allow(response).to receive_messages(status: 200, body: { 'data' => 'success' })
        allow(connection).to receive(:send).and_return(response)
      end

      it 'returns response body' do
        expect(request.perform).to eq({ 'data' => 'success' })
      end
    end

    context 'when request fails' do
      context 'with 401 status' do
        before do
          allow(response).to receive_messages(status: 401, body: { 'message' => 'Invalid API key' })
        end

        it 'raises AuthenticationError' do
          expect { request.perform }.to raise_error(SamcartAPI::AuthenticationError)
        end
      end

      context 'with 403 status' do
        before do
          allow(response).to receive_messages(status: 403, body: { 'message' => 'Access denied' })
        end

        it 'raises AuthenticationError' do
          expect { request.perform }.to raise_error(SamcartAPI::AuthenticationError)
        end
      end

      context 'with 404 status' do
        before do
          allow(response).to receive_messages(status: 404, body: { 'message' => 'Not found' })
        end

        it 'raises ApiError' do
          expect { request.perform }.to raise_error(SamcartAPI::ApiError)
        end
      end

      context 'with other error status' do
        before do
          allow(response).to receive_messages(status: 500, body: { 'message' => 'Server error' })
        end

        it 'raises ApiError' do
          expect { request.perform }.to raise_error(SamcartAPI::ApiError)
        end
      end
    end
  end
end
