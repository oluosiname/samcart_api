# frozen_string_literal: true

module SamcartAPI
  # Client for interacting with the SamCart API
  class Client
    def initialize(api_key = nil)
      @api_key = api_key || SamcartAPI.configuration.api_key
      raise ConfigurationError, 'API key is required' unless @api_key
    end

    def products
      @products ||= Product.new(self)
    end

    def orders
      @orders ||= Order.new(self)
    end

    def get(path, params = {})
      request(:get, path, params)
    end

    def post(path, body = {})
      request(:post, path, body)
    end

    def put(path, body = {})
      request(:put, path, body)
    end

    def delete(path)
      request(:delete, path)
    end

    private

    def request(method, path, params = nil)
      ApiRequest.new(method, path, params, @api_key).perform
    end
  end
end
