require 'product'

describe Product do
  subject(:product) { described_class }

  let(:product_items) {
    [
      ['Test Vegemite Scroll', 'T-VS5', 5, 8.99],
      ['Test Blueberry Muffin', 'T-MB11', 2, 9.95],
      ['Test Blueberry Muffin', 'T-MB11', 7, 9.95]
    ]
  }

  describe 'product creation' do
    it 'product can be created successfully with valid values' do
      expect { product.new('Test Product', 'TP-1') }.to_not raise_exception
    end

    it 'raise exception when product is build with invalid values' do
      expect { product.new('Test Product', '') }.to raise_error('Code must be present')
    end
  end

  describe "#build" do
    it 'builds products successfully when order line items are valid' do
      expect { product.build_all(product_items) }.to_not raise_exception
    end

    it 'raises exception when product code is invalid' do
      expect { product.build_all([['Test Vegemite Scroll', '', 5, 8.99]]) }
        .to raise_error('Code must be present')
    end

    it 'raises exception when product name is invalid' do
      expect { product.build_all([['', 'T-VS57', 5, 8.99]]) }
        .to raise_error('Name must be present')
    end

    it 'raises exception when product data is invalid' do
      expect { product.build_all([['T-VS57', 5, 8.99]]) }
        .to raise_error('Incorrect product data at line 1')
    end

    it 'raises exception when product package already exists with same size' do
      expect { product.build_all(product_items +
        [['Test Vegemite Scroll', 'T-VS5', 5, 11.99]])
      }.to raise_error('Package exists with same size')
    end
  end

  describe "#add_package" do
    let(:product_item) { product.new('Test Vegemite Scroll', 'T-VS5') }

    it 'add package successfully' do
      expect { product_item.add_package(5, 5.66) }.to_not raise_exception
    end

    it 'raise package exists error' do
      product_item.add_package(5, 5.66)
      expect { product_item.add_package(5, 4.66) }
        .to raise_error('Package exists with same size')
    end
  end
end
