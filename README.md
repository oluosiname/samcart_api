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
SamcartApi.configure do |config|
  config.api_key = 'your_api_key'
end
```

### Products

```ruby
# Find a specific product
product = SamcartApi::Product.find('123')

# Access product attributes
product.id          # => "123"
product.name        # => "Test Product"
product.price       # => "99.99"
product.created_at  # => Time object
```

### Orders

```ruby
# Find a specific order
order = SamcartApi::Order.find('123')

# Access order attributes
order.id          # => "123"
order.status      # => "completed"
order.total       # => "99.99"
order.created_at  # => Time object
```

### Direct API Access

If you need to make custom API calls, you can use the client directly:

```ruby
client = SamcartApi::Client.new('your_api_key')

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
