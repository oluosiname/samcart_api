# frozen_string_literal: true

require 'spec_helper'
require 'samcart_api'

RSpec.describe SamcartAPI::Customer do
  let(:client) { instance_double(SamcartAPI::Client) }
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

  before do
    allow(SamcartAPI::Client).to receive(:new).and_return(client)
    allow(client).to receive(:get).and_return(customer_data)
  end

  describe '.find' do
    it 'returns customer data' do
      customer = described_class.find(1337)

      expect(client).to have_received(:get).with("#{described_class::RESOURCE_PATH}/1337")
      expect(customer).to be_a(Hash)
      expect(customer['id']).to eq(1337)
      expect(customer['first_name']).to eq('John')
      expect(customer['last_name']).to eq('Doe')
      expect(customer['email']).to eq('jdoe@gmail.com')
      expect(customer['customer_tags'].first['name']).to eq('new')
      expect(customer['lifetime_value']).to eq(95025)

      address = customer['addresses'].first
      expect(address['type']).to eq('shipping')
      expect(address['street']).to eq('221B Baker Street')
      expect(address['city']).to eq('Austin')
    end
  end
end
