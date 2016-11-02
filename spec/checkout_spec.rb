require 'spec_helper'

describe Checkout do
  before(:each) do
    @product1 = Product.new('001', 'Test Product', 8.75)
    @product2 = Product.new('002', 'Test Product2', 6.00)
    @promotional_rules = PromotionalRule.new
    @promotional_rules.set_global_discount(20.0, 20)
    @promotional_rules.add_product_discount(@product1.code, 2, 8.0)
    @checkout = Checkout.new(@promotional_rules)
  end

  describe "scan" do
    it "adds product to checkout" do
      expect(@checkout.products.empty?).to eq(true)
      @checkout.scan(@product1)
      expect(@checkout.products.empty?).to eq(false)
      expect(@checkout.products.first).to eq(@product1)
    end
    it "calculates total value" do
      expect(@checkout.total).to eq(0)
      @checkout.scan(@product1)
      expect(@checkout.total).to eq(8.75)
    end
    it "calculates total value for more product discounts" do
      expect(@checkout.total).to eq(0)
      @checkout.scan(@product1)
      @checkout.scan(@product1)
      @checkout.scan(@product1)
      @promotional_rules.add_product_discount(@product2.code, 2, 5.0)
      @checkout.scan(@product2)
      @checkout.scan(@product2)
      expect(@checkout.total).to eq(27.2)
    end
  end

  describe "total" do
    it "returns calculated total value" do
      expect(@checkout.total).to eq(0)
      @checkout.scan(@product1)
      expect(@checkout.total).to eq(8.75)
      @checkout.scan(@product1)
      expect(@checkout.total).to eq(16.0)
      @checkout.scan(@product1)
      expect(@checkout.total).to eq(19.2)
    end
  end

  describe "products_codes" do
    it "returns string with codes of products added to checkout" do
      expect(@checkout.products_codes).to eq('')
      @checkout.scan(@product1)
      @checkout.scan(@product2)
      expect(@checkout.products_codes).to eq('001, 002')
    end
  end

  describe "products" do
    it "returns scaned products" do
      @checkout.scan(@product1)
      @checkout.scan(@product2)
      expect(@checkout.products).to eq([@product1, @product2])
    end
  end

  describe "global_discount?" do
    it "returns true if checkout has a global discount" do
      expect(@checkout.send(:global_discount?, 25.0)).to eq(true)
    end
    it "returns false if checkout does not have a global discount" do
      expect(@checkout.send(:global_discount?, 15.0)).to eq(false)
    end
  end

  describe "global_discount" do
    it "calculates total checkout with global discount" do
      expect(@checkout.send(:global_discount, 24.0)).to eq(19.2)
    end
  end
  
  describe "count_products" do
    it "calculates products added to checkout" do
      @checkout.scan(@product1)
      @checkout.scan(@product1)
      @checkout.scan(@product2)
      expect(@checkout.send(:count_products)).to eq({@product1 => 2, @product2 => 1})
    end
  end

  describe "updated_total" do
    it "updates total checkout price after product scan" do
      @checkout.send(:updated_total)
      expect(@checkout.total).to eq(0)
      @checkout.scan(@product1)
      @checkout.send(:updated_total)
      expect(@checkout.total).to eq(@product1.price)
    end
    it "updates total checkout price after promotional product scan" do
      @checkout.send(:updated_total)
      expect(@checkout.total).to eq(0)
      @checkout.scan(@product1)
      @checkout.scan(@product1)
      @checkout.send(:updated_total)
      expect(@checkout.total).to eq(16.0)
    end
  end
  
  describe "product_discount?" do
    it "returns true if checkout has a product discount" do
      expect(@checkout.send(:product_discount?, @product1, 2)).to eq(true)
      expect(@checkout.send(:product_discount?, @product1, 3)).to eq(true)
    end
    it "returns false if checkout does not have a product discount" do
      expect(@checkout.send(:product_discount?, @product1, 1)).to eq(false)
      expect(@checkout.send(:product_discount?, @product2, 1)).to eq(false)
      expect(@checkout.send(:product_discount?, @product2, 2)).to eq(false)
    end
  end

end