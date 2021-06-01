require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    it "is valid if info of name, price, quantity, category is provided" do
      @category = Category.new({name: "Test"})
      @product = Product.new({name: "name", price: 100, quantity: 2, category: @category})
      expect(@product.valid?).to be true
    end
    
    it "fails if name is missing" do
      @category = Category.new({name: "Test"})
      @product = Product.new({name: nil, price: 100, quantity: 2, category: @category})
      expect(@product.valid?).to be false
      expect(@product.errors.full_messages_for(:name)).to eq ["Name can't be blank"]
      # puts @product.errors.full_messages
    end

    it "fails if price is missing" do
      @category = Category.new({name: "Test"})
      @product = Product.new({name: "name", price: nil, quantity: 2, category: @category})
      expect(@product.valid?).to be false
      expect(@product.errors.full_messages_for(:price)).to include "Price is not a number", "Price can't be blank"
    end

    it "fails if quantity is missing" do
      @category = Category.new({name: "Test"})
      @product = Product.new({name: "name", price: 100, quantity: nil, category: @category})
      expect(@product.valid?).to be false
      expect(@product.errors.full_messages_for(:quantity)).to include "Quantity can't be blank"
    end

    it "fails if category is missing" do
      @category = Category.new({name: "Test"})
      @product = Product.new({name: "name", price: 100, quantity: 2, category: nil})
      expect(@product.valid?).to be false
      expect(@product.errors.full_messages_for(:category)).to include "Category can't be blank"
    end

  end
  
end