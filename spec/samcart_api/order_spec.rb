# frozen_string_literal: true

require 'spec_helper'
require 'samcart_api'

RSpec.describe SamcartApi::Order do
  let(:client) { instance_double(SamcartApi::Client) }

  let(:order_data) do
    {
      'id' => 1337,
      'customer_id' => 1234,
      'affiliate_id' => 1001,
      'test_mode' => true,
      'order_date' => '2021-03-08 00:18:35',
      'cart_items' => [
        {
          'id' => 1234,
          'product_id' => 1234,
          'subscription_id' => 1234,
          'sku' => 'sku1234',
          'internal_product_name' => 'internal-book-product',
          'product_name' => 'Book',
          'charge_id' => 1234,
          'pricing_type' => 'one_time',
          'processor_transaction_id' => '01234ABCD',
          'currency' => 'USD',
          'quantity' => 2,
          'status' => 'charged',
        },
      ],
      'subtotal' => 10000,
      'discount' => 1000,
      'taxes' => 500,
      'shipping' => 300,
      'shipping_address' => {
        'type' => 'shipping',
        'street' => '221B Baker Street',
        'postal_code' => 1234,
        'city' => 'Austin',
        'state' => 'TX',
        'region' => 'Quebec',
        'country' => 'United States',
      },
      'total' => 9800,
      'card_used' => '0123',
      'processor_name' => 'Stripe',
      'custom_fields' => {
        'Name' => {
          'value' => 'Blue',
          'slug' => 'custom_zL6FLFM3',
        },
      },
      'upsell_custom_fields' => {},
      'utm_parameters' => {
        'medium' => 'string',
        'source' => 'string',
        'campaign' => 'string',
        'content' => 'string',
        'lead_source' => 'string',
      },
      'custom_parameters' => {},
    }
  end

  before do
    allow(SamcartApi::Client).to receive(:new).and_return(client)
    allow(client).to receive(:get).and_return(order_data)
  end

  describe '#find' do
    it 'returns a single Order instance' do
      order = described_class.find('1337')

      expect(order.id).to eq(1337)
      expect(order.customer_id).to eq(1234)
      expect(order.affiliate_id).to eq(1001)
      expect(order.test_mode).to be(true)
      expect(order.order_date).to eq('2021-03-08 00:18:35')
      expect(order.cart_items).to eq([
        {
          'id' => 1234,
          'product_id' => 1234,
          'subscription_id' => 1234,
          'sku' => 'sku1234',
          'internal_product_name' => 'internal-book-product',
          'product_name' => 'Book',
          'charge_id' => 1234,
          'pricing_type' => 'one_time',
          'processor_transaction_id' => '01234ABCD',
          'currency' => 'USD',
          'quantity' => 2,
          'status' => 'charged',
        },
      ])
    end
  end
end
