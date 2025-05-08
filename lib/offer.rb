# Interface for offer strategies
# Time Complexity: Depends on implementation
class Offer
  # Apply the offer to calculate discount
  # @param basket_items [Array<BasketItem>] items in the basket
  # @param items_by_code [Hash] optional hash map of items by product code
  # @return [Float] the discount amount
  def apply(basket_items, items_by_code = nil)
    raise NotImplementedError, "Subclasses must implement #apply"
  end
end

# Buy one, get second half price offer
# Time Complexity: O(1) with hash map, O(n) without
class BuyOneGetSecondHalfPriceOffer < Offer
  # Initialize with the product code eligible for the offer
  # @param product_code [String] the product code for the offer
  def initialize(product_code)
    @product_code = product_code
  end

  # Apply the offer to calculate discount
  # Optimized to use the items_by_code hash for O(1) lookup
  # @param basket_items [Array<BasketItem>] items in the basket
  # @param items_by_code [Hash] optional hash map of items by product code
  # @return [Float] the discount amount
  def apply(basket_items, items_by_code = nil)
    # Fast path: If we have the items_by_code hash, use it for O(1) lookup
    if items_by_code && items_by_code.key?(@product_code)
      item = items_by_code[@product_code]
      # Calculate pairs directly from quantity
      pairs_count = item.quantity / 2
      discount = pairs_count * (item.product.price / 2.0)
      return discount
    end
    
    # Slow path: Fallback to O(n) if we don't have the hash
    applicable_items = basket_items.select { |item| item.product.code == @product_code }
    pairs_count = applicable_items.sum(&:quantity) / 2
    discount = pairs_count * (applicable_items.first&.product&.price || 0) / 2.0
    
    discount
  end
end 