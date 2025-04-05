# frozen_string_literal: true

module SamcartAPI
  class Product
    RESOURCE_PATH = '/products'

    class << self
      def find(id)
        product = client.get("#{RESOURCE_PATH}/#{id}")
        SamcartAPI::SamcartObject.new(product)
      end

      def client
        SamcartAPI::Client.new
      end

      def all(filters: {}, limit: 100)
        params = filters.merge(limit:)

        SamcartAPI::Paginator.new(client, RESOURCE_PATH, params)
      end
    end
  end
end
