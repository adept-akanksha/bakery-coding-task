require_relative 'line_item'
require_relative 'helper_methods'

class Order
  extend HelperMethods

  attr_accessor :line_items

  def initialize(line_items)
    @line_items = line_items
  end

  def total_amount
    line_items.map(&:total_amount).sum.round(2)
  end

  def print_invoice
    puts "-------------------------------"

    line_items.each do |line_item|
      puts line_item.get_print_format
    end

    puts "-------------------------------"
    puts "Total: $#{total_amount}"
  end

  def self.build(order_line_items)
    raise 'Request could not be serve as no order placed' if blank?(order_line_items)
    Order.new(LineItem.build_all(order_line_items))
  end
end
