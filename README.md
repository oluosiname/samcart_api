# SamCart API

A Ruby gem for interacting with the SamCart API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'samcart_api'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install samcart_api
```

## Usage

### Configuration

```ruby
SamcartAPI.configure do |config|
  config.api_key = 'your_api_key'
end
```

### Products

#### Finding a specific product

```ruby
# Find a specific product
product = SamcartAPI::Product.find('123')

# Access product attributes
product.id          # => "123"
product.name        # => "Test Product"
product.price       # => "99.99"
product.created_at  # => Time object

```

#### Retrieve All Products with Pagination

By default, `SamcartAPI::Product.all` returns a **Paginator object**, allowing you to iterate through paginated results efficiently.

Using `each_page` to **Iterate Over Paginated Results**

```ruby
SamcartAPI::Product.all.each_page do |products|
  products.each do |product|
    puts "Product ID: #{product['id']}, Name: #{product['product_name']}"
  end
end
```

#### Filter Products

You can filter products using query parameters such as `status`, `created_at_min`, `created_at_max`, `product_category`, and `pricing_type`. See [getProducts](https://developer.samcart.com/#tag/Products/operation/getProducts)

### Orders

#### Finding a specific order

```ruby
# Find a specific order
order = SamcartAPI::Order.find('123')

# Access order attributes
order.id          # => "123"
order.status      # => "completed"
order.total       # => "99.99"
order.created_at  # => Time object

# Get charges for an order (returns raw hash data)
charges = SamcartAPI::Order.charges('123')
charges.first['id']                    # => 1337
charges.first['customer_id']           # => 1234
charges.first['processor_name']        # => "Stripe"
charges.first['charge_refund_status']  # => "partially_refunded"
charges.first['total']                 # => 10025
charges.first['currency']              # => "USD"
charges.first['card_used']            # => "4242"
```

#### Retrieve All Orders with Pagination

By default, `SamcartAPI::Order.all` returns a **Paginator object**, allowing you to iterate through paginated results efficiently.

Using `each_page` to **Iterate Over Paginated Results**

```ruby
SamcartAPI::Order.all.each_page do |orders|
  orders.each do |order|
    puts "Order ID: #{order['id']}"
  end
end
```

### Direct API Access

If you need to make custom API calls, you can use the client directly:

```ruby
client = SamcartAPI::Client.new('your_api_key')

# GET request
response = client.get('/products')

# POST request
response = client.post('/orders', { product_id: '123' })

# PUT request
response = client.put('/products/123', { name: 'Updated Name' })

# DELETE request
response = client.delete('/products/123')
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the MIT License.
