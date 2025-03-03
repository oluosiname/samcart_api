# frozen_string_literal: true

module SamcartApi
  class Order
    RESOURCE_PATH = '/orders'

    class << self
      def find(id)
        new(id).find
      end
    end

    def initialize(id)
      @id = id
    end

    def find
      order = client.get("#{RESOURCE_PATH}/#{id}")
      SamcartApi::SamcartObject.new(order)
    end

    private

    attr_reader :id

    def client
      @client ||= SamcartApi::Client.new
    end
  end
end
