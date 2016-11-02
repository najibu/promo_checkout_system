class PromotionalRule
	attr_accessor :global_discount, :product_discounts

  def initialize
    @global_discount = {}
    @product_discounts = []
  end

  def add_product_discount product_code, amount, value
    @product_discounts << {product_code: product_code, amount: amount, value: value}
  end

  def set_global_discount value, percent
    @global_discount = {value: value, percent: percent}
  end

  def promotional_product product_code
    unless @product_discounts.empty?
      @product_discounts.each do |product_discount|
        return product_discount if product_discount[:product_code] == product_code
      end
    end
    return nil
  end
end