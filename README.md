# Acme Widget Co Sales System

A proof-of-concept sales system for Acme Widget Co that calculates basket totals with delivery charges and special offers.

## Features

- Product catalog management
- Flexible delivery charge rules
- Extensible special offers system
- Shopping basket with add and total functionality

## Design Principles

- **Separation of Concerns**: Each class has a single responsibility
- **Dependency Injection**: Components are passed into the Basket rather than created inside
- **Strategy Pattern**: Delivery calculators and offers use the strategy pattern for extensibility
- **Optimized Performance**: Hash-based lookups for O(1) time complexity where possible

## Implementation Details

### Products
- Red Widget (R01): $32.95
- Green Widget (G01): $24.95
- Blue Widget (B01): $7.95

### Delivery Charges
- Orders under $50: $4.95 delivery
- Orders under $90: $2.95 delivery
- Orders $90 or more: Free delivery

### Special Offers
- Buy one Red Widget, get the second half price

## Assumptions

1. Product codes are case-insensitive (converted to uppercase)
2. The "buy one, get second half price" offer applies to pairs of the same product
3. Delivery charges are calculated after discounts are applied
4. All monetary values are in USD with 2 decimal places

## Time Complexity

- **Product Catalog Operations**: O(1) for lookups using hash map
- **Basket#add**: O(1) using hash-based lookup
- **Basket#subtotal**: O(n) where n is the number of items
- **Basket#discount**: O(m) where m is the number of offers
- **Offer#apply**: O(1) for most offers using the optimized hash lookup
- **Basket#total**: O(n + m) where n is items and m is offers

## Project Structure

- `lib/`: Core classes
  - `product.rb`: Product model
  - `product_catalog.rb`: Manages available products
  - `delivery_calculator.rb`: Calculates delivery charges
  - `offer.rb`: Implements special offers
  - `basket_item.rb`: Represents an item in the basket
  - `basket.rb`: Main basket implementation
  - `acme_sales_system.rb`: System setup
- `test/`: Test files
  - `basket_test.rb`: Tests for the basket functionality
- `bin/`: Executable scripts
  - `run.rb`: Interactive demo script 