# frozen_string_literal: true

module SamcartAPI
  class Customer
    RESOURCE_PATH = '/customers'

    class << self
      def find(id)
        client.get("#{RESOURCE_PATH}/#{id}")
      end

      def client
        SamcartAPI::Client.new
      end
    end
  end
end
