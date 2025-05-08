require_relative 'basket_item'

# Manages the shopping basket
# Time Complexity: Most operations O(n) where n is number of items
class Basket
  attr_reader :items

  # Initialize a new basket
  # @param product_catalog [ProductCatalog] the product catalog
  # @param delivery_calculator [DeliveryCalculator] for calculating delivery charges
  # @param offers [Array<Offer>] array of applicable offers
  def initialize(product_catalog, delivery_calculator, offers = [])
    @product_catalog = product_catalog
    @delivery_calculator = delivery_calculator
    @offers = offers
    @items = []
    # Use a hash to track items by product code for O(1) lookup
    @items_by_code = {}
  end

  # Add a product to the basket by its code
  # @param product_code [String] the code of the product to add
  # @raise [RuntimeError] if product code is not found
  # Time Complexity: O(1)
  def add(product_code)
    # O(1) lookup in the product catalog
    product = @product_catalog.find_by_code(product_code)
    raise "Product not found: #{product_code}" unless product

    # O(1) lookup in our items hash
    if @items_by_code.key?(product_code)
      @items_by_code[product_code].add_quantity
    else
      item = BasketItem.new(product)
      @items << item
      @items_by_code[product_code] = item
    end
  end

  # Calculate the subtotal of all items before discounts and delivery
  # @return [Float] the subtotal
  # Time Complexity: O(n) where n is number of items
  def subtotal
    # O(n) time complexity, can't be improved further
    @items.sum(&:total_price)
  end

  # Calculate the total discount from all offers
  # @return [Float] the total discount
  # Time Complexity: O(m) where m is number of offers
  def discount
    # O(m) where m is the number of offers
    @offers.sum { |offer| offer.apply(@items, @items_by_code) }
  end

  # Calculate the delivery charge based on the post-discount subtotal
  # @return [Float] the delivery charge
  # Time Complexity: O(1) assuming few delivery tiers
  def delivery_charge
    # O(1) time complexity
    @delivery_calculator.calculate(subtotal - discount)
  end

  # Calculate the total cost including discounts and delivery
  # @return [Float] the total cost
  # Time Complexity: O(n + m) where n is items and m is offers
  def total
    # O(n + m) time complexity
    subtotal - discount + delivery_charge
  end
  
  # Format the total as a currency string
  # @return [String] formatted total with $ and 2 decimal places
  # Time Complexity: O(1)
  def formatted_total
    # O(1) time complexity
    format("$%.2f", total)
  end
end 