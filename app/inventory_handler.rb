# frozen_string_literal: true

class InventoryHandler
  def initialize
    @inventory = []
    generate_inventory
  end

  def display_inventory
    puts 'Inventory:'
    @inventory.each do |item|
      puts "#{item[:name]}: Price: #{item[:price].to_f}, Quantity: #{item[:quantity]}"
    end
  end

  def get_item(item)
    @inventory.find { |i| i[:name] == item }
  end

  private

  def generate_inventory
    @inventory = [
      { name: 'Coke', price: 5, quantity: 2 },
      { name: 'Chocolate Bar', price: 7.25, quantity: 2 },
      { name: 'Water', price: 3, quantity: 1 },
      { name: 'Chips', price: 5.5, quantity: 3 }
    ]
  end
end
