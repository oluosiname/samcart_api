# frozen_string_literal: true

module SamcartAPI
  class SamcartObject
    def initialize(attributes = {})
      @attributes = attributes
    end

    def [](key)
      @attributes[key]
    end

    def method_missing(method_name, *args)
      if @attributes.key?(method_name.to_s)
        @attributes[method_name.to_s]
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @attributes.key?(method_name.to_s) || super
    end

    def to_h
      @attributes
    end
  end
end
