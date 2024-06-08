# frozen_string_literal: true

require './app/vending_machine'
require 'rspec'

RSpec.describe VendingMachine do
  let(:coins_handler) { instance_double('CoinsHandler') }
  let(:inventory_handler) { instance_double('InventoryHandler') }
  let(:vending_machine) { VendingMachine.new }

  before do
    allow(CoinsHandler).to receive(:new).and_return(coins_handler)
    allow(InventoryHandler).to receive(:new).and_return(inventory_handler)
  end

  describe '#greatings' do
    it 'outputs the welcome message' do
      expect { vending_machine.greatings }.to output("Welcome to the SA Vending Machine!\n").to_stdout
    end
  end

  describe '#display_balance' do
    it 'displays current balance' do
      vending_machine.instance_variable_set(:@balance, 10.0)
      expect { vending_machine.display_balance }.to output(/Current balance: 10.0/).to_stdout
    end
  end

  describe '#display_inventory' do
    it 'displays available items' do
      expect(inventory_handler).to receive(:display_inventory)

      vending_machine.display_inventory
    end
  end

  describe '#display_coins_change' do
    it 'displays available coins for change' do
      expect(coins_handler).to receive(:display_coins_change)

      vending_machine.display_coins_change
    end
  end

  describe '#display_coins' do
    it 'displays all valid coins' do
      expect(coins_handler).to receive(:display_coins)

      vending_machine.display_coins
    end
  end

  describe '#select_item' do
    before do
      expect(inventory_handler).to receive(:get_item).with(anything).and_return(inventory_response)
    end

    context 'when item is in stock' do
      let(:inventory_response) { { name: 'Coke', price: 5, quantity: 2 } }
      it 'selects the item' do
        expect { vending_machine.select_item('Coke') }.to output(/Selected item: Coke, Price: 5/).to_stdout
      end
    end

    context 'when item is out of stock' do
      let(:inventory_response) { { name: 'Coke', price: 5, quantity: 0 } }
      it 'indicates the item is out of stock' do
        expect { vending_machine.select_item('Coke') }.to output(/Item out of stock/).to_stdout
      end
    end

    context 'when item is invalid' do
      let(:inventory_response) { nil }
      it 'indicates invalid selection' do
        expect { vending_machine.select_item('Invalid') }.to output(/Invalid selection/).to_stdout
      end
    end
  end

  describe '#insert_coin' do
    context 'when coin is valid' do
      it 'inserts the coin and updates the balance' do
        expect(coins_handler).to receive(:valid_coin?).with(1).and_return(true)
        expect(coins_handler).to receive(:stock_coins).with(1, 1).and_return(true)

        expect { vending_machine.insert_coin(1) }.to output(/Inserted coin: 1, Current balance: 1.0/).to_stdout
        expect(vending_machine.instance_variable_get(:@balance)).to eq(1.0)
      end
    end

    context 'when coin is invalid' do
      it 'indicates invalid coin' do
        expect(coins_handler).to receive(:valid_coin?).with(0.1).and_return(false)
        expect { vending_machine.insert_coin(0.1) }.to output(/Invalid coin/).to_stdout
      end
    end
  end

  describe '#vend' do
    before do
      allow(coins_handler).to receive(:valid_coin?).with(anything).and_return(true)
      allow(coins_handler).to receive(:stock_coins).with(anything, anything).and_return(true)
      allow(inventory_handler).to receive(:get_item).with('Coke').and_return({ name: 'Coke', price: 5, quantity: 1 })
      allow(inventory_handler).to receive(:get_item).with('Water').and_return({ name: 'Water', price: 3, quantity: 1 })
    end

    context 'when balance is sufficient and change is available' do
      it 'vends the item and returns change' do
        expect { vending_machine.select_item('Coke') }.to output(/Selected item: Coke, Price: 5/).to_stdout

        expect { vending_machine.insert_coin(10) }.to output(/Inserted coin: 10, Current balance: 10.0/).to_stdout
        expect { vending_machine.insert_coin(3) }.to output(/Inserted coin: 3, Current balance: 13.0/).to_stdout
        expect { vending_machine.insert_coin(0.25) }.to output(/Inserted coin: 0.25, Current balance: 13.25/).to_stdout
        expect { vending_machine.insert_coin(0.25) }.to output(/Inserted coin: 0.25, Current balance: 13.5/).to_stdout

        expect(coins_handler).to receive(:enough_change?).with(8.5).and_return(true)
        expect(coins_handler).to receive(:dispense_change).with(8.5)
        expect { vending_machine.vend }.to output(/Dispensing item: Coke/).to_stdout
        expect(vending_machine.instance_variable_get(:@balance)).to eq(0)
        expect(inventory_handler.get_item('Coke')[:quantity]).to eq(0)
      end
    end

    context 'when balance is insufficient' do
      it 'asks for more coins' do
        expect { vending_machine.select_item('Coke') }.to output(/Selected item: Coke, Price: 5/).to_stdout
        expect { vending_machine.insert_coin(1) }.to output(/Inserted coin: 1, Current balance: 1.0/).to_stdout
        expect { vending_machine.vend }.to output(/Not enough balance. Please insert more coins./).to_stdout
      end
    end

    context 'when change is not available' do
      it 'cancels the transaction' do
        vending_machine.instance_variable_set(:@coin_change, { 0.25 => 1, 0.5 => 1, 1 => 1, 2 => 0, 3 => 1, 5 => 2 })
        expect { vending_machine.select_item('Water') }.to output(/Selected item: Water, Price: 3/).to_stdout
        expect { vending_machine.insert_coin(5) }.to output(/Inserted coin: 5, Current balance: 5.0/).to_stdout
        expect(coins_handler).to receive(:enough_change?).with(2).and_return(false)
        expect { vending_machine.vend }.to output(/Cannot provide change, transaction canceled/).to_stdout
      end
    end

    context 'when no item is selected' do
      it 'indicates no item selected' do
        expect { vending_machine.vend }.to output(/No item selected/).to_stdout
      end
    end
  end
end
