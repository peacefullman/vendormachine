# frozen_string_literal: true

class VendingMachine
  COINS = [0.25, 0.5, 1, 2, 3, 5].freeze

  def initialize
    @inventory = {}
    @balance = 0.0
    @coin_change = Hash.new(0)
  end

  def greatings
    puts 'Welcome to the SA Vending Machine!'
  end

  def display_balance
    puts "Current balance: #{@balance.to_f}"
  end

  def display_inventory
    puts 'Inventory:'
    @inventory.each do |item, details|
      puts "#{item}: Price: #{details[:price]}, Quantity: #{details[:quantity]}"
    end
  end

  def display_coin_change
    puts 'Coin change:'
    @coin_change.each do |coin, quantity|
      puts "#{coin}: #{quantity}"
    end
  end

  def display_coins
    puts "Coins accepted: #{COINS.join(', ')}"
  end

  def display_commands
    puts 'Commands:'
    puts 'display_commands - Display available commands'
    puts 'display_coins - Display accepted coins'
    puts 'display_balance - Display current balance'
    puts 'display_inventory - Display current inventory'
    puts 'insert_coin <coin> - Insert a coin'
    puts 'select_item <item> - Select an item'
    puts 'vend - Vend the selected item'
    puts 'exit - Exit the vending machine'
  end

  def select_item(item)
    if @inventory[item]
      if (@inventory[item][:quantity]).positive?
        puts "Selected item: #{item}, Price: #{@inventory[item][:price]}"
        @selected_item = item
      else
        puts 'Item out of stock'
      end
    else
      puts 'Invalid selection'
    end
  end

  def insert_coin(coin)
    if COINS.include?(coin)
      @balance += coin
      @coin_change[coin] += 1
      puts "Inserted coin: #{coin}, Current balance: #{@balance.to_f}"
    else
      puts 'Invalid coin'
    end
  end

  def vend
    if @selected_item
      item_price = @inventory[@selected_item][:price]
      if @balance >= item_price
        change = @balance - item_price
        if enough_change?(change)
          dispense_change(change)
          @inventory[@selected_item][:quantity] -= 1
          puts "Dispensing item: #{@selected_item}"
          @selected_item = nil
        else
          puts 'Cannot provide change, transaction canceled'
        end
        @balance = 0
      else
        puts 'Not enough balance. Please insert more coins.'
      end
    else
      puts 'No item selected'
    end
  end

  def stock_item(item, price, quantity)
    @inventory[item] = { price: price, quantity: quantity }
  end

  def stock_coins(coin, quantity)
    @coin_change[coin] += quantity
  end

  private

  def enough_change?(amount)
    calculate_change(amount).nil? ? false : true
  end

  def calculate_change(amount)
    return {} if amount.zero?

    change_to_return = {}
    COINS.reverse.each do |coin|
      next if amount.zero? || amount < coin

      coin_count = [(amount / coin).to_i, @coin_change[coin]].min
      amount -= coin_count * coin
      change_to_return[coin] = coin_count if coin_count.positive?
    end
    amount.zero? ? change_to_return : nil
  end

  def dispense_change(amount)
    change = calculate_change(amount)
    return unless change

    puts 'Dispensing change:'
    change.each do |coin, count|
      puts "#{coin} * #{count}"
      @coin_change[coin] -= count
    end
  end
end
