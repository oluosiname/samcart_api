# frozen_string_literal: true

module SamcartApi
  class Product
    RESOURCE_PATH = '/products'

    class << self
      def find(id)
        new(id).find
      end
    end

    def initialize(id)
      @id = id
    end

    def find
      product = client.get("#{RESOURCE_PATH}/#{id}")
      SamcartApi::SamcartObject.new(product)
    end

    private

    attr_reader :id

    def client
      @client ||= SamcartApi::Client.new
    end
  end
end
