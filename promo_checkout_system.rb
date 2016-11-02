#author Najibu Nsubuga  <ns.najibu@gmail.com>
require './lib/checkout.rb'
require './lib/product.rb'
require './lib/promotional_rule.rb'

item1 = Product.new('001', 'Lavender heart', 9.25)
item2 = Product.new('002', 'Personalised cufflinks', 45.00)
item3 = Product.new('003', 'Kids T-shirt', 19.95)

promotional_rules = PromotionalRule.new
promotional_rules.set_global_discount(60.0, 10)
promotional_rules.add_product_discount('001', 2, 8.50)

co = Checkout.new(promotional_rules)
co.scan(item1)
co.scan(item2)
price = co.total

puts "Basket: #{co.products_codes}"
puts "Total price expected: #{price}"

co = Checkout.new(promotional_rules)
co.scan(item1)
co.scan(item3)
co.scan(item1)
price = co.total

puts "Basket: #{co.products_codes}"
puts "Total price expected: #{price}"

co = Checkout.new(promotional_rules)
co.scan(item1)
co.scan(item2)
co.scan(item1)
co.scan(item3)
price = co.total

puts "Basket: #{co.products_codes}"
puts "Total price expected: #{price}"