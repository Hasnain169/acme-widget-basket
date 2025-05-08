# Represents a product in the catalog
# Time Complexity: All operations O(1)
class Product
  attr_reader :code, :name, :price

  # Initialize a new product with code, name and price
  # @param code [String] unique product identifier
  # @param name [String] human-readable product name
  # @param price [Float] product price
  def initialize(code, name, price)
    @code = code
    @name = name
    @price = price
  end
end 