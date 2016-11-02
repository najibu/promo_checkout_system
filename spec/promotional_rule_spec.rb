require 'spec_helper'
 
describe PromotionalRule do
  before(:each) do
    @promotional_rules_with_discounts = PromotionalRule.new
    @promotional_rules_with_discounts.set_global_discount(20.0, 5)
    @promotional_rules_with_discounts.add_product_discount('001', 3, 5.00)
    @empty_promotional_rules = PromotionalRule.new
  end

  describe "global_discount" do
    it "returns correct global discount" do
      expect(@promotional_rules_with_discounts.global_discount).to eq({value: 20.0, percent: 5})
      expect(@promotional_rules_with_discounts.global_discount[:value]).to eq(20.0)
      expect(@promotional_rules_with_discounts.global_discount[:percent]).to eq(5)
    end
  end

  describe "product_discounts" do
    it "returns correct product discount" do
      expect(@promotional_rules_with_discounts.product_discounts).to eq([{product_code: '001', amount: 3, value: 5.00}])
      expect(@promotional_rules_with_discounts.product_discounts.first[:product_code]).to eq('001')
      expect(@promotional_rules_with_discounts.product_discounts.first[:amount]).to eq(3)
      expect(@promotional_rules_with_discounts.product_discounts.first[:value]).to eq(5.00)
    end
  end

  describe "set_global_discount" do
    it "sets a global discount promotional rule" do
      expect(@empty_promotional_rules.global_discount).to eq({})
      @empty_promotional_rules.set_global_discount 10.0, 3
      expect(@empty_promotional_rules.global_discount).to eq({value: 10.0, percent: 3})
    end
    it "overwrites a global discount promotional rule" do
      expect(@promotional_rules_with_discounts.global_discount).to eq({value: 20.0, percent: 5})
      @promotional_rules_with_discounts.set_global_discount 10.0, 3
      expect(@promotional_rules_with_discounts.global_discount).to eq({value: 10.0, percent: 3})
    end
  end
  
  describe "add_product_discount" do
    it "adds a product discount promotional rule" do
      expect(@empty_promotional_rules.product_discounts).to eq([])
      @empty_promotional_rules.add_product_discount '1001', 2, 4.0
      @empty_promotional_rules.add_product_discount '2002', 3, 5.0
      expect(@empty_promotional_rules.product_discounts).to eq([{product_code: '1001', amount: 2, value: 4.0},{product_code: '2002', amount: 3, value: 5.0}])
    end
  end
  
  describe "promotional_product" do
    it "returns product discount information if product is promotional" do
      expect(@promotional_rules_with_discounts.promotional_product('000')).to eq(nil)
      expect(@promotional_rules_with_discounts.promotional_product('001')).to eq({product_code: "001", amount: 3, value: 5.0})
    end
  end
end