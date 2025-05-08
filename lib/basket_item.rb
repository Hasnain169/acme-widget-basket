# Represents an item in the basket
# Time Complexity: All operations O(1)
class BasketItem
  attr_reader :product, :quantity

  # Initialize a new basket item
  # @param product [Product] the product
  # @param quantity [Integer] initial quantity (default: 1)
  def initialize(product, quantity = 1)
    @product = product
    @quantity = quantity
  end

  # Increase the quantity of this item
  # @param amount [Integer] amount to add (default: 1)
  # @return [Integer] the new quantity
  def add_quantity(amount = 1)
    @quantity += amount
  end

  # Calculate the total price for this item
  # @return [Float] product price * quantity, rounded to 2 decimal places
  def total_price
    (@product.price * @quantity).round(2)
  end
end 