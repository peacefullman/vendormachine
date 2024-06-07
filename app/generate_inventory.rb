# frozen_string_literal: true

class GenerateInventory
  def initialize(vending_machine)
    @vending_machine = vending_machine
  end

  def call
    @vending_machine.stock_item('Coke', 5, 2)
    @vending_machine.stock_item('Chocolate Bar', 7.25, 2)
    @vending_machine.stock_item('Water', 3, 1)
    @vending_machine.stock_item('Chips', 5.5, 3)
    VendingMachine::COINS.each do |coin|
      @vending_machine.stock_coins(coin, 10)
    end
  end
end
