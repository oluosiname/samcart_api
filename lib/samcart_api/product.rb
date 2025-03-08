# frozen_string_literal: true

module SamcartApi
  class Product
    RESOURCE_PATH = '/products'

    class << self
      def find(id)
        product = client.get("#{RESOURCE_PATH}/#{id}")
        SamcartApi::SamcartObject.new(product)
      end

      def client
        @client ||= SamcartApi::Client.new
      end

      def all(limit: 100)
        SamcartApi::Paginator.new(client, RESOURCE_PATH, limit)
      end
    end
  end
end
