# frozen_string_literal: true

require 'faraday'
require 'json'
require 'active_support'
require 'active_support/core_ext'

module SamcartApi
  VERSION = '0.1.0'

  class Error < StandardError; end
  class ConfigurationError < Error; end
  class AuthenticationError < Error; end
  class ApiError < Error; end

  autoload :SamcartObject, 'samcart_api/samcart_object'
  autoload :Product, 'samcart_api/product'
  autoload :Order, 'samcart_api/order'
  autoload :Client, 'samcart_api/client'
  autoload :ApiRequest, 'samcart_api/api_request'

  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end

  class Configuration
    attr_accessor :api_key, :api_url, :version

    def initialize
      @api_url = 'https://api.samcart.com'
      @version = 'v1'
    end
  end
end
