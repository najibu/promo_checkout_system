require 'spec_helper'
 
describe Product do
  before(:each) do
    @product = Product.new('001', 'Test Product', 8.75)
  end

  describe "code" do
    it "returns correct product code" do
      expect(@product.code).to eq('001')
    end
    it "returns product code as string" do
      expect(@product.code.class).to eq(String)
    end
  end

  describe "name" do
    it "returns correct product name" do
      expect(@product.name).to eq('Test Product')
    end
    it "returns product name as string" do
      expect(@product.name.class).to eq(String)
    end
  end

  describe "price" do
    it "returns correct product price value" do
      expect(@product.price).to eq(8.75)
    end
    it "returns product name as string" do
      expect(@product.price.class).to eq(Float)
    end
  end
end