# frozen_string_literal: true

require './app/vending_machine'
require './app/generate_inventory'
require 'rspec'

RSpec.describe VendingMachine do
  let(:vending_machine) { VendingMachine.new }

  before do
    GenerateInventory.new(vending_machine).call
  end

  describe '#display_balance' do
    it 'displays current balance' do
      vending_machine.insert_coin(1)
      expect { vending_machine.display_balance }.to output(/Current balance: 1.0/).to_stdout
    end
  end

  describe '#display_inventory' do
    it 'displays available items' do
      expect { vending_machine.display_inventory }.to output(/Inventory:/).to_stdout
    end
  end

  describe '#display_coin_change' do
    it 'displays available coins for change' do
      expect { vending_machine.display_coin_change }.to output(/Coin change:/).to_stdout
    end
  end

  describe '#display_coins' do
    it 'displays available coins for change' do
      expect { vending_machine.display_coins }.to output(/Coins accepted:/).to_stdout
    end
  end

  describe '#select_item' do
    context 'when item is in stock' do
      it 'selects the item' do
        expect { vending_machine.select_item('Coke') }.to output(/Selected item: Coke, Price: 5/).to_stdout
      end
    end

    context 'when item is out of stock' do
      it 'indicates the item is out of stock' do
        vending_machine.instance_variable_get(:@inventory)['Coke'][:quantity] = 0
        expect { vending_machine.select_item('Coke') }.to output(/Item out of stock/).to_stdout
      end
    end

    context 'when item is invalid' do
      it 'indicates invalid selection' do
        expect { vending_machine.select_item('Invalid') }.to output(/Invalid selection/).to_stdout
      end
    end
  end

  describe '#stock_item' do
    it 'stocks items correctly' do
      vending_machine.stock_item('Water', 1.0, 15)
      expect(vending_machine.instance_variable_get(:@inventory)['Water']).to eq({ price: 1.0, quantity: 15 })
    end
  end

  describe '#stock_coins' do
    it 'stocks coins correctly' do
      vending_machine.stock_coins(1, 10)
      expect(vending_machine.instance_variable_get(:@coin_change)[1]).to eq(20)
    end
  end

  describe '#insert_coin' do
    context 'when coin is valid' do
      it 'inserts the coin and updates the balance' do
        expect { vending_machine.insert_coin(1) }.to output(/Inserted coin: 1, Current balance: 1.0/).to_stdout
        expect(vending_machine.instance_variable_get(:@balance)).to eq(1.0)
      end
    end

    context 'when coin is invalid' do
      it 'indicates invalid coin' do
        expect { vending_machine.insert_coin(0.1) }.to output(/Invalid coin/).to_stdout
      end
    end
  end

  describe '#vend' do
    context 'when balance is sufficient and change is available' do
      it 'vends the item and returns change' do
        vending_machine.select_item('Coke')
        vending_machine.insert_coin(5)
        vending_machine.insert_coin(5)
        vending_machine.insert_coin(3)
        vending_machine.insert_coin(0.25)
        vending_machine.insert_coin(0.25)
        expect do
          vending_machine.vend
        end.to output(include('Dispensing change:', '5 * 1', '3 * 1', '0.5 * 1',
                              'Dispensing item: Coke')).to_stdout
        expect(vending_machine.instance_variable_get(:@balance)).to eq(0)
        expect(vending_machine.instance_variable_get(:@inventory)['Coke'][:quantity]).to eq(1)
      end
    end

    context 'when balance is insufficient' do
      it 'asks for more coins' do
        vending_machine.select_item('Coke')
        vending_machine.insert_coin(1)
        expect { vending_machine.vend }.to output(/Not enough balance. Please insert more coins./).to_stdout
      end
    end

    context 'when change is not available' do
      it 'cancels the transaction' do
        vending_machine.instance_variable_set(:@coin_change, { 0.25 => 1, 0.5 => 1, 1 => 1, 2 => 0, 3 => 1, 5 => 2 })
        vending_machine.select_item('Water')
        vending_machine.insert_coin(5)
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
