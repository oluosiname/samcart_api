# frozen_string_literal: true

module SamcartApi
  class ApiRequest
    def initialize(method, path, params, api_key)
      @method = method
      @path = path
      @params = params
      @api_key = api_key
    end

    def perform
      response = connection.send(@method) do |req|
        req.url @path
        req.params = @params if @params
        req.headers['Authorization'] = "Bearer #{@api_key}"
        req.headers['Content-Type'] = 'application/json'
      end

      handle_response(response)
    end

    private

    def connection
      @connection ||= Faraday.new(url: SamcartApi.configuration.api_url) do |conn|
        conn.response :json
        conn.adapter Faraday.default_adapter
      end
    end

    def handle_response(response)
      case response.status
      when 200..299
        response.body
      when 401
        raise AuthenticationError, 'Invalid API key'
      when 403
        raise AuthenticationError, 'Access denied'
      when 404
        raise ApiError, 'Resource not found'
      else
        raise ApiError, "API request failed: #{response.body["message"] || response.body}"
      end
    end
  end
end
