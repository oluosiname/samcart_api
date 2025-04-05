# frozen_string_literal: true

require 'spec_helper'
require 'samcart_api'

RSpec.describe SamcartAPI::Product do
  let(:product_data) do
    {
      'id' => 1337,
      'sku' => 'sku123',
      'internal_product_name' => 'internal-book-product',
      'product_name' => 'Book',
      'description' => 'This is a good book',
      'currency' => 'USD',
      'price' => 1025,
      'product_category' => 'physical',
      'pricing_type' => 'one_time',
      'status' => 'live',
      'taxes' => true,
      'upsell_funnel' => 'Additional Offer',
      'order_bumps' => [
        {
          'product_id' => 1234,
          'product_name' => 'Binder',
        },
      ],
      'bundled_products' => [
        {
          'product_id' => 3423,
          'product_name' => 'Magazine',
        },
      ],
      'slug' => 'book',
      'custom_domain' => 'https://google.com',
      'product_tags' => [
        {
          'name' => 'digital',
        },
      ],
      'created_at' => '2021-01-14 18:03:59',
      'updated_at' => '2021-01-14 18:03:59',
      'archived_date' => '2021-01-14 18:03:59',
    }
  end

  describe '#find' do
    let(:client) { instance_double(SamcartAPI::Client) }

    before do
      allow(SamcartAPI::Client).to receive(:new).and_return(client)
      allow(client).to receive(:get).and_return(product_data)
    end

    it 'returns a single Product instance' do
      product = described_class.find('1337')

      expect(product.id).to eq(1337)
      expect(product.sku).to eq('sku123')
      expect(product.internal_product_name).to eq('internal-book-product')
      expect(product.product_name).to eq('Book')
      expect(product.description).to eq('This is a good book')
      expect(product.currency).to eq('USD')
      expect(product.price).to eq(1025)
    end
  end

  describe '#all' do
    context 'when filtering products' do
      let(:client) { instance_double(SamcartAPI::Client) }
      let(:filters) do
        {
          status: 'live',
          created_at_min: '2021-01-01',
          created_at_max: '2021-01-31',
          product_category: 'digital',
          pricing_type: 'one_time',
        }
      end

      before do
        allow(SamcartAPI::Client).to receive(:new).and_return(client)
        allow(client).to receive(:get).and_return({
          'data' => [product_data],
          'pagination' => { 'next' => nil },
        })
      end

      it 'returns a collection of Product instances' do
        paginator = described_class.all(filters:)
        paginator.each_page do |products|
          expect(products.size).to eq(1)
        end

        expected_query = '/products?' + URI.encode_www_form(filters.merge(limit: 100).sort.to_h)

        expect(client).to have_received(:get).with(expected_query)
      end
    end
  end
end
