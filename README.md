# Vending Machine Project

## Overview

This project is a simple simulation of a vending machine implemented in Ruby. It allows users to interact with the vending machine through various commands to insert coins, select items, and vend items. The machine also handles inventory and provides change if necessary.

## Features

- Display available commands
- Display accepted coins
- Display available coins for change
- Display current balance
- Display current inventory
- Insert coins
- Select an item to vend
- Vend the selected item
- Exit the vending machine

## Requirements

- Ruby (>= 2.7.0)

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/vending_machine.git
    cd vending_machine
    ```

2. Ensure all files are present:
    ```sh
    ls
    # Should list:
    # - main.rb
    # - app/vending_machine.rb
    # - app/generate_inventory.rb
    # - app/coins_handler.rb
    # - app/inventory_handler.rb
    ```

## Usage

1. Run the vending machine program:
    ```sh
    ruby main.rb
    ```

2. Interact with the vending machine using the following commands:

### Commands

- `display_commands` - Display available commands
- `display_coins` - Display accepted coins
- `display_coins_change` - Display available coins for change
- `display_balance` - Display current balance
- `display_inventory` - Display current inventory
- `insert_coin <coin>` - Insert a coin (e.g., `insert_coin 1`)
- `select_item <item>` - Select an item (e.g., `select_item Coke`)
- `vend` - Vend the selected item
- `exit` - Exit the vending machine

### Example Session

```plaintext
Welcome to the SA Vending Machine!
Current balance: 0.0
Commands:
display_commands - Display available commands
display_coins - Display accepted coins
display_coins_change - Display available coins for change
display_balance - Display current balance
display_inventory - Display current inventory
insert_coin <coin> - Insert a coin
select_item <item> - Select an item
vend - Vend the selected item
exit - Exit the vending machine
Enter a command:
display_inventory
Inventory:
Coke: Price: 5.0, Quantity: 2
Chocolate Bar: Price: 7.25, Quantity: 2
Water: Price: 3.0, Quantity: 1
Chips: Price: 5.5, Quantity: 3
insert_coin 5
Inserted coin: 5.0, Current balance: 5.0
select_item Coke
Selected item: Coke, Price: 5.0
vend
Dispensing item: Coke
Dispensing change:
Goodbye!
