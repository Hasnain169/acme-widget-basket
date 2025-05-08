require 'minitest/autorun'
require_relative '../lib/acme_sales_system'

# Test cases for the Basket class
class BasketTest < Minitest::Test
  def setup
    @basket = AcmeSalesSystem.setup
  end

  # Test case: Blue Widget + Green Widget = $37.85
  def test_basket_b01_g01
    @basket.add('B01')
    @basket.add('G01')
    assert_equal "$37.85", @basket.formatted_total
  end

  # Test case: Red Widget + Red Widget = $54.37
  # Tests the "buy one, get second half price" offer
  def test_basket_r01_r01
    @basket.add('R01')
    @basket.add('R01')
    assert_equal "$54.37", @basket.formatted_total
  end

  # Test case: Red Widget + Green Widget = $60.85
  def test_basket_r01_g01
    @basket.add('R01')
    @basket.add('G01')
    assert_equal "$60.85", @basket.formatted_total
  end

  # Test case: Blue Widget + Blue Widget + Red Widget + Red Widget + Red Widget = $98.27
  # Tests multiple items and the "buy one, get second half price" offer with 3 red widgets
  def test_basket_b01_b01_r01_r01_r01
    @basket.add('B01')
    @basket.add('B01')
    @basket.add('R01')
    @basket.add('R01')
    @basket.add('R01')
    assert_equal "$98.27", @basket.formatted_total
  end
end 