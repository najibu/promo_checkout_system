class Checkout
	attr_accessor :products 

	def initialize(promotional_rules)
	  @promotional_rules = promotional_rules
	  @total = 0
	  @products = []
	end

	def scan product
		@products << product 
		updated_total 
	end

	def total
    global_discount?(@total) ? global_discount(@total) : @total
  end

  def products_codes
    @products.map(&:code).join(", ")
  end

	private
		def updated_total
			total_discount = 0
			count_products.each do |product, count|
				if product_discount?(product, count)
		        total_discount += @promotional_rules.promotional_product(product.code)[:value] * count
		      else
		        total_discount += product.price * count
		      end
		    end
		    @total = total_discount
		end

		def global_discount? value
	    !@promotional_rules.global_discount.empty? && value > @promotional_rules.global_discount[:value]
	  end

	  def global_discount value
	    (value - (@promotional_rules.global_discount[:percent] * value / 100)).round(2)
	  end

	  def count_products
	    @products.inject(Hash.new(0)) {|k,v| k[v] += 1; k }
	  end

		def product_discount? product, count
			promotional_product = @promotional_rules.promotional_product(product.code)
	    unless promotional_product.nil?
	      return true if count >= promotional_product[:amount]
	    end
	    return false
		end
end