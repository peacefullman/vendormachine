# frozen_string_literal: true

require_relative 'coins_handler'
require_relative 'inventory_handler'

class VendingMachine
  def initialize
    @balance = 0.0
    @inventory = InventoryHandler.new
    @coins_handler = CoinsHandler.new
  end

  def greatings
    puts 'Welcome to the SA Vending Machine!'
  end

  def display_balance
    puts "Current balance: #{@balance.to_f}"
  end

  def display_inventory
    @inventory.display_inventory
  end

  def display_coins_change
    @coins_handler.display_coins_change
  end

  def display_coins
    @coins_handler.display_coins
  end

  def display_commands
    puts 'Commands:'
    puts 'display_commands - Display available commands'
    puts 'display_coins - Display accepted coins'
    puts 'display_coins_change - Display available coins for change'
    puts 'display_balance - Display current balance'
    puts 'display_inventory - Display current inventory'
    puts 'insert_coin <coin> - Insert a coin'
    puts 'select_item <item> - Select an item'
    puts 'vend - Vend the selected item'
    puts 'exit - Exit the vending machine'
  end

  def select_item(item)
    inventory_item = @inventory.get_item(item)
    if inventory_item
      if (inventory_item[:quantity]).positive?
        puts "Selected item: #{inventory_item[:name]}, Price: #{inventory_item[:price]}"
        @selected_item = inventory_item
      else
        puts 'Item out of stock'
      end
    else
      puts 'Invalid selection'
    end
  end

  def insert_coin(coin)
    if @coins_handler.valid_coin?(coin)
      @balance += coin
      @coins_handler.stock_coins(coin, 1)
      puts "Inserted coin: #{coin}, Current balance: #{@balance.to_f}"
    else
      puts 'Invalid coin'
    end
  end

  def vend
    if @selected_item
      item_price = @selected_item[:price]
      if @balance >= item_price
        change = @balance - item_price
        if @coins_handler.enough_change?(change)
          @coins_handler.dispense_change(change)
          @selected_item[:quantity] -= 1
          puts "Dispensing item: #{@selected_item[:name]}"
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
end
