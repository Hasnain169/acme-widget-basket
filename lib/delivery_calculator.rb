# Interface for delivery charge calculation strategies
# Time Complexity: Depends on implementation
class DeliveryCalculator
  # Calculate delivery charge based on subtotal
  # @param subtotal [Float] the basket subtotal
  # @return [Float] the delivery charge
  def calculate(subtotal)
    raise NotImplementedError, "Subclasses must implement #calculate"
  end
end

# Tiered delivery charge calculator based on order subtotal
# Time Complexity: O(n) where n is the number of tiers
class TieredDeliveryCalculator < DeliveryCalculator
  # Initialize with delivery charge tiers
  # @param tiers [Array<Hash>] array of threshold/cost pairs
  # Each tier should have :threshold and :cost keys
  def initialize(tiers)
    # Sort tiers by threshold in descending order for efficient matching
    @tiers = tiers.sort_by { |tier| -tier[:threshold] }
  end

  # Calculate delivery charge based on subtotal
  # @param subtotal [Float] the basket subtotal
  # @return [Float] the delivery charge
  def calculate(subtotal)
    # Find the first tier where subtotal >= threshold
    # Time Complexity: O(n) where n is number of tiers (typically very small)
    @tiers.each do |tier|
      return tier[:cost] if subtotal >= tier[:threshold]
    end
    
    # Return the cost of the last tier if no threshold is met
    @tiers.last[:cost]
  end
end 