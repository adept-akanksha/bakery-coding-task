require_relative 'product'

class Bakery
  class << self
    attr_accessor :products

    def build_products(inventory_list_tems)
      @products = Product.build_all(inventory_list_tems)
    end

    def find_product(code)
      products.find { |product| product.code == code.downcase }
    end
  end
end
