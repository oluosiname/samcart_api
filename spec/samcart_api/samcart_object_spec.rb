# frozen_string_literal: true

require 'spec_helper'
require 'samcart_api'

RSpec.describe SamcartAPI::SamcartObject do
  subject(:object) { described_class.new(attributes) }

  let(:attributes) do
    {
      'id' => '123',
      'name' => 'Test Product',
      'price' => '99.99',
      'created_at' => '2024-01-01T00:00:00Z',
      'updated_at' => '2024-01-01T00:00:00Z',
    }
  end

  describe '#initialize' do
    it 'sets attributes' do
      expect(object.to_h).to eq(attributes)
    end
  end

  describe '#[]' do
    it 'returns attribute value by key' do
      expect(object['id']).to eq('123')
      expect(object['name']).to eq('Test Product')
    end
  end

  describe 'method_missing' do
    it 'returns attribute value when method name matches attribute key' do
      expect(object.id).to eq('123')
      expect(object.name).to eq('Test Product')
      expect(object.price).to eq('99.99')
    end

    it 'raises NoMethodError for unknown methods' do
      expect { object.unknown_method }.to raise_error(NoMethodError)
    end
  end

  describe '#respond_to_missing?' do
    it 'returns true for existing attributes' do
      expect(object.respond_to?(:id)).to be true
      expect(object.respond_to?(:name)).to be true
      expect(object.respond_to?(:price)).to be true
    end

    it 'returns false for unknown methods' do
      expect(object.respond_to?(:unknown_method)).to be false
    end
  end

  describe '#to_h' do
    it 'returns the attributes hash' do
      expect(object.to_h).to eq(attributes)
    end
  end
end
