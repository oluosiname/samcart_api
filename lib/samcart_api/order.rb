# frozen_string_literal: true

module SamcartAPI
  class Order
    RESOURCE_PATH = '/orders'

    class << self
      def find(id)
        order = client.get("#{RESOURCE_PATH}/#{id}")
        SamcartAPI::SamcartObject.new(order)
      end

      def client
        SamcartAPI::Client.new
      end

      def all(filters: {}, limit: 100)
        params = filters.merge(limit:)
        SamcartAPI::Paginator.new(client, RESOURCE_PATH, params)
      end

      def charges(order_id)
        client.get("#{RESOURCE_PATH}/#{order_id}/charges")
      end

      def customer(order_id)
        client.get("#{RESOURCE_PATH}/#{order_id}/customer")
      end

      def subscriptions(order_id)
        client.get("#{RESOURCE_PATH}/#{order_id}/subscriptions")
      end
    end
  end
end
