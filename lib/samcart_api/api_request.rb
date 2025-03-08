# frozen_string_literal: true

module SamcartApi
  class ApiRequest
    RETRY_ATTEMPTS = 3

    def initialize(method, path, params, api_key)
      @method = method
      @path = path
      @params = params
      @api_key = api_key
      @version = SamcartApi.configuration.version
    end

    def perform
      safe_request { make_request }
    end

    private

    def make_request
      response = connection.send(@method) do |req|
        req.url "/#{@version}#{@path}"
        req.params = @params if @params
        req.headers['Accept'] = 'application/json'
        req.headers['sc-api'] = @api_key
        req.headers['Content-Type'] = 'application/json'
      end

      handle_response(response)
    end

    def safe_request
      retries = 0

      begin
        yield
      rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
        puts "Network error: #{e.message}. Retrying..."
        sleep 2
        retries += 1
        retry if retries < RETRY_ATTEMPTS
        raise 'Too many retries: Network issues'
      rescue ApiError => e
        if e.message.include?('Too Many Requests') # Custom handling for 429
          wait_time = 5 # Default wait
          puts "Rate limited! Retrying in #{wait_time} seconds..."
          sleep wait_time
          retries += 1
          retry if retries < RETRY_ATTEMPTS
          raise 'Too many retries: Rate limited'
        else
          raise
        end
      end
    end

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
      when 429
        raise ApiError, 'Too Many Requests'
      else
        raise ApiError, "API request failed: #{response.body["message"] || response.body}"
      end
    end
  end
end
