# frozen_string_literal: true

class CoinsHandler
  COINS = [0.25, 0.5, 1, 2, 3, 5].freeze

  def initialize
    @coins_change = []
    COINS.each { |coin| @coins_change << { value: coin, amount: 10 } }
  end

  def display_coins_change
    puts 'Coin change:'
    @coins_change.each do |coin|
      puts "#{coin[:value]} * #{coin[:amount]}"
    end
  end

  def display_coins
    puts "Coins accepted: #{COINS.join(', ')}"
  end

  def stock_coins(coin, quantity)
    get_coin(coin)[:amount] += quantity
  end

  def valid_coin?(coin)
    COINS.include?(coin)
  end

  def enough_change?(amount)
    calculate_change(amount).nil? ? false : true
  end

  def dispense_change(amount)
    change = calculate_change(amount)

    return unless change

    puts 'Dispensing change:'
    change.each do |coin, count|
      puts "#{coin} * #{count}"
      get_coin(coin)[:amount] -= count
    end
  end

  private

  def calculate_change(amount)
    return {} if amount.zero?

    change_to_return = {}
    COINS.reverse.each do |coin|
      next if amount.zero? || amount < coin

      coins_count = [(amount / coin).to_i, get_coin(coin)[:amount]].min
      amount -= coins_count * coin
      change_to_return[coin] = coins_count if coins_count.positive?
    end
    amount.zero? ? change_to_return : nil
  end

  def get_coin(coin)
    @coins_change.find { |c| c[:value] == coin }
  end
end
