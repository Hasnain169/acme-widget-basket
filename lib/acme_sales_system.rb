require_relative 'product'
require_relative 'product_catalog'
require_relative 'delivery_calculator'
require_relative 'offer'
require_relative 'basket'

# Set up the Acme Widget Co sales system
# Time Complexity: O(1) for setup
class AcmeSalesSystem
  # Set up and return a new basket with all dependencies
  # @return [Basket] a configured basket ready for use
  def self.setup
    # Create products
    red_widget = Product.new('R01', 'Red Widget', 32.95)
    green_widget = Product.new('G01', 'Green Widget', 24.95)
    blue_widget = Product.new('B01', 'Blue Widget', 7.95)
    
    # Create product catalog
    catalog = ProductCatalog.new([red_widget, green_widget, blue_widget])
    
    # Create delivery calculator with tiered pricing
    delivery_calculator = TieredDeliveryCalculator.new([
      { threshold: 90, cost: 0 },      # Free delivery for orders $90+
      { threshold: 50, cost: 2.95 },   # $2.95 delivery for orders $50-$89.99
      { threshold: 0, cost: 4.95 }     # $4.95 delivery for orders under $50
    ])
    
    # Create offers
    offers = [
      BuyOneGetSecondHalfPriceOffer.new('R01')  # Buy one red widget, get second half price
    ]
    
    # Create and return a new basket
    Basket.new(catalog, delivery_calculator, offers)
  end
end 