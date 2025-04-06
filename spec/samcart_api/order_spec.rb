# frozen_string_literal: true

require 'spec_helper'
require 'samcart_api'

RSpec.describe SamcartAPI::Order do
  let(:client) { instance_double(SamcartAPI::Client) }

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
    allow(SamcartAPI::Client).to receive(:new).and_return(client)
  end

  describe '.find' do
    before do
      allow(client).to receive(:get).with('/orders/1337').and_return(order_data)
    end

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

  describe '.all' do
    context 'when no filtering' do
      it_behaves_like 'a paginated API resource', resource_path: '/orders'
    end

    context 'when filtering orders' do
      let(:filters) do
        {
          test_mode: true,
          created_at_max: '2021-03-08',
          created_at_min: '2021-03-01',
        }
      end

      before do
        allow(client).to receive(:get).and_return({
          'data' => [order_data],
          'pagination' => {
            'next' => nil,
          },
        })
      end

      it 'returns a Paginator instance with the correct path and params' do
        paginated_orders = described_class.all(filters:)
        paginated_orders.each_page do |orders|
          expect(orders.size).to eq(1)
        end

        expected_query = '/orders?' + URI.encode_www_form(filters.merge(limit: 100).sort.to_h)

        expect(client).to have_received(:get).with(expected_query)
      end
    end
  end

  describe '.charges' do
    let(:order_id) { '123' }
    let(:charges_data) do
      [
        {
          'id' => 1337,
          'customer_id' => 1234,
          'affiliate_id' => 1001,
          'order_id' => 1001,
          'subscription_rebill_id' => 1001,
          'test_mode' => true,
          'processor_name' => 'Stripe',
          'processor_transaction_id' => '01234ABCD',
          'currency' => 'USD',
          'card_used' => '4242',
          'charge_refund_status' => 'partially_refunded',
          'order_date' => '2021-03-08 00:18:35',
          'created_at' => '2021-03-08 00:18:35',
          'total' => 10025,
        },
      ]
    end

    before do
      allow(client)
        .to receive(:get)
        .with("#{described_class::RESOURCE_PATH}/#{order_id}/charges")
        .and_return(charges_data)
    end

    it 'returns an array of charge hashes' do
      charges = described_class.charges(order_id)
      expect(charges).to be_an(Array)
      expect(charges.first).to be_a(Hash)
      expect(charges.first['id']).to eq(1337)
      expect(charges.first['customer_id']).to eq(1234)
      expect(charges.first['processor_name']).to eq('Stripe')
      expect(charges.first['total']).to eq(10025)
      expect(charges.first['currency']).to eq('USD')
      expect(charges.first['card_used']).to eq('4242')

      expect(client).to have_received(:get).with("#{described_class::RESOURCE_PATH}/#{order_id}/charges")
    end
  end

  describe '.customer' do
    let(:order_id) { '123' }
    let(:customer_data) do
      {
        'id' => 1337,
        'first_name' => 'John',
        'last_name' => 'Doe',
        'email' => 'jdoe@gmail.com',
        'phone' => '5555555555',
        'customer_tags' => [
          {
            'name' => 'new',
          },
        ],
        'lifetime_value' => 95025,
        'updated_at' => '2020-03-04 00:18:35',
        'created_at' => '2020-03-04 00:18:35',
        'addresses' => [
          {
            'type' => 'shipping',
            'street' => '221B Baker Street',
            'postal_code' => 1234,
            'city' => 'Austin',
            'state' => 'TX',
            'region' => 'Quebec',
            'country' => 'United States',
          },
        ],
      }
    end

    it 'returns customer data for the order' do
      allow(client).to receive(:get).and_return(customer_data)
      customer = described_class.customer(order_id)
      expect(customer).to be_a(Hash)
      expect(customer['id']).to eq(1337)
      expect(customer['first_name']).to eq('John')
      expect(customer['last_name']).to eq('Doe')
      expect(customer['email']).to eq('jdoe@gmail.com')
      expect(customer['customer_tags'].first['name']).to eq('new')
      expect(customer['addresses'].first['street']).to eq('221B Baker Street')

      expect(client).to have_received(:get)
        .with("#{described_class::RESOURCE_PATH}/#{order_id}/customer")
    end
  end

  describe '.subscriptions' do
    let(:order_id) { '123' }
    let(:subscriptions_data) do
      [
        {
          'id' => 1337,
          'customer_id' => 1234,
          'affiliate_id' => 1001,
          'order_id' => 1001,
          'product_id' => 1001,
          'sku' => 'sku123',
          'status' => 'active',
          'type' => 'recurring_subscription',
          'product_name' => 'Cool Product',
          'internal_product_name' => 'Cool Product',
          'initial_price' => {
            'subtotal' => 10000,
            'taxes' => 500,
            'shipping' => 300,
            'total' => 9800,
          },
          'recurring_price' => {
            'subtotal' => 10000,
            'taxes' => 500,
            'shipping' => 300,
            'total' => 10800,
          },
          'coupon' => {
            'id' => '1234',
            'charge_instance' => 'one_time',
            'code' => 'summersale',
            'type' => 'flat_rate',
            'discount_amount' => nil,
            'discount_percentage' => 10,
          },
          'cancel_schedule' => {
            'status' => 'scheduled',
            'cancel_date' => '2021-03-08 00:18:35',
          },
          'processor_name' => 'Stripe',
          'test_mode' => true,
          'card_used' => '4242',
          'created_at' => '2021-03-08 00:18:35',
          'start_date' => '2021-03-08 00:18:35',
          'end_date' => '2021-03-08 00:18:35',
          'next_rebilling_date' => '2021-04-08 00:18:35',
          'total_failed_charges' => 1,
        },
      ]
    end

    before do
      allow(client).to receive(:get).and_return(subscriptions_data)
    end

    it 'returns subscriptions data for the order' do
      subscriptions = described_class.subscriptions(order_id)

      expect(client).to have_received(:get)
        .with("#{described_class::RESOURCE_PATH}/#{order_id}/subscriptions")

      expect(subscriptions).to be_an(Array)
      expect(subscriptions.first).to be_a(Hash)

      subscription = subscriptions.first
      expect(subscription['id']).to eq(1337)
      expect(subscription['status']).to eq('active')
      expect(subscription['type']).to eq('recurring_subscription')
      expect(subscription['product_name']).to eq('Cool Product')
      expect(subscription['initial_price']['total']).to eq(9800)
      expect(subscription['recurring_price']['total']).to eq(10800)
      expect(subscription['coupon']['code']).to eq('summersale')
      expect(subscription['cancel_schedule']['status']).to eq('scheduled')
    end
  end
end
