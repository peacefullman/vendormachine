# frozen_string_literal: true

require_relative 'app/vending_machine'
require_relative 'app/generate_inventory'

def main
  vending_machine = VendingMachine.new
  vending_machine.greatings
  vending_machine.display_balance
  vending_machine.display_commands
  puts 'Enter a command:'

  loop do
    input = gets.chomp
    command, *params = input.split(/\s/)

    case command
    when /\Adisplay_commands\z/i
      vending_machine.display_commands
    when /\Adisplay_coins\z/i
      vending_machine.display_coins
    when /\Adisplay_balance\z/i
      vending_machine.display_balance
    when /\Adisplay_inventory\z/i
      vending_machine.display_inventory
    when /\Ainsert_coin\z/i
      vending_machine.insert_coin(params.first.to_f)
    when /\Adisplay_coins_change\z/i
      vending_machine.display_coins_change
    when /\Aselect_item\z/i
      vending_machine.select_item(params.join(' '))
    when /\Avend\z/i
      vending_machine.vend
    when /\Aexit\z/i
      puts 'Goodbye!'
      break
    else
      puts 'Invalid command'
    end
  end
end

main if __FILE__ == $PROGRAM_NAME
