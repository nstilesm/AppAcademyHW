require 'rspec'
require 'dessert'

=begin
Instructions: implement all of the pending specs (the `it` statements without blocks)! Be sure to look over the solutions when you're done.
=end

describe Dessert do
  let(:chef) { double("chef", name: "Nick") }
  subject(:dessert) {Dessert.new("cake",2, chef)}
  subject(:dessert2) {Dessert.new("cake",'two', chef)}
  

  describe "#initialize" do
    it "sets a type" do
        expect(dessert.type).to eq("cake")
    end
    it "sets a quantity" do
        expect(dessert.quantity).to eq(2)
    end
    it "starts ingredients as an empty array" do
        expect(dessert.ingredients).to be_empty
    end
    it "raises an argument error when given a non-integer quantity" do
        expect{ (dessert2.quantity) }.to raise_error(ArgumentError)
    end
    
  end

  describe "#add_ingredient" do
    it "adds an ingredient to the ingredients array" do
      dessert.add_ingredient("flour")
      expect(dessert.ingredients).to include('flour')
    end
  end

  describe "#mix!" do
    it "shuffles the ingredient array" do
      parts = ['flour','salt','sugar','eggs','butter']

      parts.each do |input|
        dessert.add_ingredient(input)
      end
      dessert.mix!
      
      expect(parts).to_not eq(dessert.ingredients)
    end
  end

  describe "#eat" do
    it "subtracts an amount from the quantity" do
      dessert.eat(1)
      expect(dessert.quantity).to eq(1)
    end

    it "raises an error if the amount is greater than the quantity" do
      expect {(dessert.eat(3)) }.to raise_error ("not enough left!")
    end
  end

  describe "#serve" do
    it "contains the titleized version of the chef's name" do
      allow(chef).to receive(:titleize).and_return("Nick")
    end
  end

  describe "#make_more" do
    it "calls bake on the dessert's chef with the dessert passed in" do
      expect(chef).to receive(:bake).with(dessert)
      dessert.make_more    
    end
  end
end
