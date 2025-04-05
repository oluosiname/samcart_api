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

        warn '[DEPRECATION] Dot notation (.) is deprecated and ' \
          "will be removed in the next major version. Use hash access ['#{method_name}'] instead."
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
