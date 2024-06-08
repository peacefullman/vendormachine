# frozen_string_literal: true

require 'rspec'
require './app/coins_handler'

RSpec.describe CoinsHandler do
  let(:coins_handler) { CoinsHandler.new }

  describe '#display_coins_change' do
    it 'displays the correct coin change information' do
      coins_handler = CoinsHandler.new

      expected_output = "Coin change:\n"
      CoinsHandler::COINS.each do |coin|
        expected_output += "#{coin} * 10\n"
      end

      expect { coins_handler.display_coins_change }.to output(expected_output).to_stdout
    end
  end

  describe '#display_coins' do
    it 'displays the correct coin information' do
      coins_handler = CoinsHandler.new

      expected_output = "Coins accepted: #{CoinsHandler::COINS.join(', ')}\n"

      expect { coins_handler.display_coins }.to output(expected_output).to_stdout
    end
  end

  describe '#stock_coins' do
    it 'stocks the correct quantity of coins' do
      coins_handler = CoinsHandler.new

      coins_handler.stock_coins(1, 5)

      expect(coins_handler.send(:get_coin, 1)[:amount]).to eq(15)
    end
  end

  describe '#valid_coin?' do
    it 'returns true for valid coins' do
      coins_handler = CoinsHandler.new

      expect(coins_handler.valid_coin?(1)).to be true
    end

    it 'returns false for invalid coins' do
      coins_handler = CoinsHandler.new

      expect(coins_handler.valid_coin?(0.1)).to be false
    end
  end

  describe '#enough_change?' do
    it 'returns true when there is enough change' do
      coins_handler = CoinsHandler.new

      expect(coins_handler.enough_change?(5)).to be true
    end

    it 'returns false when there is not enough change' do
      coins_handler = CoinsHandler.new

      expect(coins_handler.enough_change?(1000)).to be false
    end

    it 'returns false when there is no change' do
      coins_handler = CoinsHandler.new

      coins_handler.instance_variable_set(:@coins_change, CoinsHandler::COINS.map { |coin| { value: coin, amount: 0 } })

      expect(coins_handler.enough_change?(1)).to be false
    end
  end

  describe '#dispense_change' do
    it 'dispenses the correct change' do
      coins_handler = CoinsHandler.new

      expected_output = "Dispensing change:\n"
      expected_output += "5 * 1\n"

      expect { coins_handler.dispense_change(5) }.to output(expected_output).to_stdout
    end

    it 'dispenses the correct change when there are multiple coins' do
      coins_handler = CoinsHandler.new

      expected_output = "Dispensing change:\n"
      expected_output += "5 * 1\n"
      expected_output += "3 * 1\n"
      expected_output += "1 * 1\n"

      expect { coins_handler.dispense_change(9) }.to output(expected_output).to_stdout
    end

    it 'dispenses the correct change when not all coins are available' do
      coins_handler = CoinsHandler.new

      coins_handler.instance_variable_set(:@coins_change, CoinsHandler::COINS.map { |coin| { value: coin, amount: 2 } })

      expected_output = "Dispensing change:\n"
      expected_output += "0.5 * 1\n"

      expect { coins_handler.dispense_change(0.5) }.to output(expected_output).to_stdout

      expected_output2 = "Dispensing change:\n"
      expected_output2 += "0.5 * 1\n"

      expect { coins_handler.dispense_change(0.5) }.to output(expected_output2).to_stdout

      expected_output3 = "Dispensing change:\n"
      expected_output3 += "0.25 * 2\n"

      expect { coins_handler.dispense_change(0.5) }.to output(expected_output3).to_stdout
    end
  end
end
