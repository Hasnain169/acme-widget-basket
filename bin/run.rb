#!/usr/bin/env ruby

require_relative '../lib/acme_sales_system'

# Create a new basket
basket = AcmeSalesSystem.setup

# Display available products
puts "Available products:"
catalog = basket.instance_variable_get(:@product_catalog)
catalog.all_products.each do |product|
  puts "#{product.code}: #{product.name} - $#{format('%.2f', product.price)}"
end
puts

# Interactive shopping
puts "Enter product codes one by one (or 'done' to finish):"
loop do
  print "> "
  input = gets.chomp.upcase
  break if input == 'DONE'
  
  begin
    basket.add(input)
    product = basket.instance_variable_get(:@product_catalog).find_by_code(input)
    puts "Added #{input} (#{product.name} - $#{format('%.2f', product.price)}) to basket."
    
    # Check if there's a discount applied
    if basket.discount > 0
      puts "Current basket total with discount: #{basket.formatted_total}"
    else
      puts "Current basket total with delivery charges: #{basket.formatted_total}"
    end
  rescue => e
    puts "Error: Please Enter The Correct Code!"
    puts "Available codes: R01 (Red Widget), G01 (Green Widget), B01 (Blue Widget)"
  end
end

# Display final basket
puts "\nFinal Basket:"
basket.items.each do |item|
  # Format the price to always show 2 decimal places
  puts "#{item.quantity}x #{item.product.name} (#{item.product.code}): $#{format('%.2f', item.total_price)}"
end

puts "\nSubtotal: $#{format('%.2f', basket.subtotal)}"
if basket.discount > 0
  puts "Discount: $#{format('%.2f', basket.discount)}"
end
puts "Delivery: $#{format('%.2f', basket.delivery_charge)}"
puts "Total: #{basket.formatted_total}" 