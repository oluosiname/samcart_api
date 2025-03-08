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
        @client ||= SamcartApi::Client.new
      end

      def all(limit: 100)
        SamcartApi::Paginator.new(client, RESOURCE_PATH, limit)
      end
    end
  end
end
