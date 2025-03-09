# frozen_string_literal: true

module SamcartApi
  class Order
    RESOURCE_PATH = '/orders'

    class << self
      def find(id)
        order = client.get("#{RESOURCE_PATH}/#{id}")
        SamcartApi::SamcartObject.new(order)
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
