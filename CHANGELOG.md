# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-04-05

### Added

- Order charges endpoint (`/orders/{id}/charges`)
  - Returns raw hash data for better performance
  - Includes transaction IDs, payment processor information, refund status, and card details

### Changed

- Renamed module from `SamcartApi` to `SamcartAPI`
- Improved performance by returning raw hash data for charges endpoint

### Deprecated

- Dot notation (.) access for API responses
  - Using object.attribute now shows a deprecation warning
  - Use hash access (object['attribute']) instead
  - Will be removed in next major version

### Migration Guide

1. Update all `SamcartApi` references to `SamcartAPI`
2. Replace all dot notation access with hash access
3. Update any code that depends on SamcartObject methods
4. Test your integration with the new hash-based responses

## [0.1.0] - 2024-03-XX

### Added

- Initial release
- Basic Product and Order endpoints
- Authentication with API key

## [Unreleased]

### Added

- Order subscriptions endpoint (`/orders/{id}/subscriptions`)
  - Returns subscription details including:
    - Subscription status and type
    - Initial and recurring pricing
    - Coupon information
    - Cancellation schedule
    - Payment processing details
    - Billing dates
