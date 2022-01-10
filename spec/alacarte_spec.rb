require "alacarte"

describe Alacarte::Waiter do
    it "waiter takes your order" do
      expect(Alacarte::Waiter.portray("Broccoli")).to eql("Gross!")
    end
  
    it "anything else is delicious" do
      expect(Alacarte::Waiter.portray("Not Broccoli")).to eql("Delicious!")
    end
  end