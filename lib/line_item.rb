require_relative 'details_builder'
require_relative 'helper_methods'
require_relative 'bakery'

class LineItem
  include DetailsBuilder
  include HelperMethods

  InvalidLineItem = Class.new(StandardError)

  attr_accessor :product, :quantity, :package_details

  def initialize(product, quantity)
    @product = product
    @quantity = quantity
    @package_details = {}

    validate!
  end

  def build_package_details
    self.package_details = get_package_details(product.packages, quantity).tally
    validate_package_details!
  end

  def total_amount
    @total_amount ||= package_details.map { |package, count| package.price * count }
                                     .sum
                                     .round(2)
  end

  def get_print_format
    ["#{quantity} #{product.code.upcase} $#{total_amount}"] + print_details_format
  end

  def self.build_all(order_line_items)
    line_items = []

    order_line_items.each_with_index do |item, index|
      raise "Incorrect line item data at line #{index + 1}" if item.length < 2

      product = Bakery.find_product(item[1])

      raise "Product with code #{item[1].upcase} not found" if product.nil?

      line_items.push self.new(product, item[0]).tap { |item| item.build_package_details }
    end

    line_items
  end

  private

  def validate!
    raise InvalidLineItem.new "Product must be present" if blank?(product)

    error = "Quantity must be present and should be a valid integer value"
    self.quantity = Integer(quantity) rescue raise(InvalidLineItem.new(error))
  end

  def validate_package_details!
    error = "Pack with size #{quantity} for product with code: "\
          "#{product.code.upcase} is not available "
    raise InvalidLineItem.new(error) if blank?(package_details)
  end

  def print_details_format
    package_details.map do |package, count|
      "   #{count.to_s} * #{package.size.to_s} $#{package.price}"
    end
  end
end
