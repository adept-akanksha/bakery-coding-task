require 'csv'
require_relative '../lib/bakery'
require_relative '../lib/Order'

INVENTORY_FILE_PATH = 'inputs/inventory_list.csv'.freeze
ORDER_LIST_ITEMS_PATH = 'inputs/order_list_items.csv'.freeze

# Create Bakery
# Initialize Products
# Create Order and generate invoice
begin
  Bakery.build_products(CSV.read(INVENTORY_FILE_PATH))
  order = Order.build(CSV.read(ORDER_LIST_ITEMS_PATH))
  order.print_invoice
rescue StandardError => e
  puts e
end

