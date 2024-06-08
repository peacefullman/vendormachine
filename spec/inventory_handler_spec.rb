# frozen_string_literal: true

require 'rspec'
require './app/inventory_handler'

RSpec.describe InventoryHandler do
  let(:inventory_handler) { InventoryHandler.new }

  describe '#display_inventory' do
    it 'displays the correct inventory information' do
      expected_output = "Inventory:\n"
      expected_output += "Coke: Price: 5.0, Quantity: 2\n"
      expected_output += "Chocolate Bar: Price: 7.25, Quantity: 2\n"
      expected_output += "Water: Price: 3.0, Quantity: 1\n"
      expected_output += "Chips: Price: 5.5, Quantity: 3\n"

      expect { inventory_handler.display_inventory }.to output(expected_output).to_stdout
    end
  end

  describe '#get_item' do
    it 'returns the correct item' do
      item = inventory_handler.get_item('Coke')

      expect(item).to eq({ name: 'Coke', price: 5, quantity: 2 })
    end

    it 'returns nil for invalid item' do
      item = inventory_handler.get_item('Invalid')

      expect(item).to be_nil
    end
  end
end
