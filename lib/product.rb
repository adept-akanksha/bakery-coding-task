require_relative 'package'
require_relative 'helper_methods'

class Product
  include HelperMethods

  InvalidProduct = Class.new(StandardError)

  attr_accessor :name, :code, :packages

  def initialize(name, code)
    @name = name
    @code = code
    @packages = []

    validate!
    downcase_fields
  end

  def add_package(size, quantity)
    raise "Package exists with same size" if Package.exists?(packages, size)
    packages.push(Package.new(size, quantity))
  end

  def self.build_all(items)
    raise "No Products available" if items.count == 0

    products = []

    items.each_with_index do |item, index|
      raise "Incorrect product data at line #{index + 1}" if item.length < 4

      product_index = products.find_index { |product| product.code == item[1].downcase }

      if product_index.nil?
        products.push self.new(item[0], item[1])
        product_index = -1
      end

      products[product_index].add_package(item[2], item[3])
    end

    products
  end

  private

  def validate!
    raise InvalidProduct.new "Name must be present" if blank?(name)
    raise InvalidProduct.new "Code must be present" if blank?(code)
  end

  def downcase_fields
    name.downcase! && code.downcase!
  end
end
