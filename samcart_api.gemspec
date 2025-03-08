# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'samcart_api'
  spec.version       = '0.2.0'
  spec.authors       = ['Olumuyiwa Osiname']
  spec.email         = ['osiname@gmail.com']

  spec.summary       = 'Ruby gem for interacting with the SamCart API'
  spec.description   = 'A Ruby gem that provides a simple interface for interacting with the SamCart API, focusing on products and orders.'
  spec.homepage      = 'https://github.com/oluosiname/samcart_api'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.glob('{bin,lib}/**/*')
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 6.0'
  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'json', '~> 2.0'

  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'vcr', '~> 6.0'
  spec.add_development_dependency 'webmock', '~> 3.0'
end
