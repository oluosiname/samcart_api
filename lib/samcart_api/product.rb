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
        SamcartApi::Client.new
      end

      def all(filters: {}, limit: 100)
        params = filters.merge(limit:)

        SamcartApi::Paginator.new(client, RESOURCE_PATH, params)
      end
    end
  end
end
