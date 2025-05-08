# Manages the product catalog with efficient lookups
# Time Complexity: All operations O(1)
class ProductCatalog
  # Initialize catalog with optional products array
  # @param products [Array<Product>] initial products to add
  def initialize(products = [])
    @products = {}  # Hash map for O(1) lookups by code
    products.each { |product| add_product(product) }
  end

  # Add a product to the catalog
  # @param product [Product] the product to add
  # @return [Product] the added product
  def add_product(product)
    @products[product.code] = product
  end

  # Find a product by its code
  # @param code [String] the product code to look up
  # @return [Product, nil] the product if found, nil otherwise
  def find_by_code(code)
    @products[code]  # O(1) hash lookup
  end
  
  # Get all products in the catalog
  # @return [Array<Product>] array of all products
  def all_products
    @products.values
  end
end 