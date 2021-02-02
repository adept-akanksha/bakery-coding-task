require 'line_item'
require 'bakery'

describe LineItem do
  subject(:line_item) { described_class }

  before do
    Bakery.build_products([
      ['Test Vegemite Scroll', 'T-VS5', 5, 8.99],
      ['Test Blueberry Muffin', 'T-MB11', 2, 9.95],
      ['Test Blueberry Muffin', 'T-MB11', 7, 9.95]
    ])
  end

  let(:product) { Bakery.products.first }
  let(:order_line_item) { line_item.new(product, 20) }

  describe 'line item test general functions' do
    it 'line item can be created successfully with valid values' do
      expect { line_item.new(product, '9') }.to_not raise_exception
    end

    context 'line item raises exceptions with invalid values' do
      it 'line item can not be created successfully with invalid params' do
        expect { line_item.new(product, '9.89') }
          .to raise_error('Quantity must be present and should be a valid integer value')
      end

      it 'line item can not be created without product' do
        expect { line_item.new('', '9') }
          .to raise_error('Product must be present')
      end

      it 'line item can not be created with product as nil' do
        expect { line_item.new(nil, '9') }
          .to raise_error('Product must be present')
      end

      it 'line item can not be created with quantity as nil' do
        expect { line_item.new(product, nil) }
          .to raise_error('Quantity must be present and should be a valid integer value')
      end
    end
  end

  describe '#build_package_details' do
    it 'build line item package details successfully' do
      expected_value = { product.packages.first => 4 }

      expect { order_line_item.build_package_details }.to_not raise_exception
      expect(order_line_item.package_details.count).to eq(1)
      expect(order_line_item.package_details).to eq(expected_value)
    end

    it 'raise exceptions when line item quantity is invalid' do
      expect { line_item.new(product, '7').build_package_details }
      .to raise_error(LineItem::InvalidLineItem)
    end

    it 'raise exceptions when line item quantity is 0' do
      expect { line_item.new(product, 0).build_package_details }
      .to raise_error(LineItem::InvalidLineItem)
    end
  end

  describe '#total_amount' do
    it 'should return a float value' do
      order_line_item.build_package_details
      expect(order_line_item.total_amount).to eq(35.96)
    end
  end

  describe '#get_print_format' do
    it 'should return invoice print format' do
      order_line_item.build_package_details
      expect(order_line_item.get_print_format).to eq(["20 T-VS5 $35.96", "   4 * 5 $8.99"])
    end
  end

  describe "#build_all" do
    it 'should build all line items with package details' do
      expect { line_item.build_all([[10, 'T-VS5']]) }.to_not raise_exception
    end

    it 'should raise exception when line items product code is invalid' do
      expect { line_item.build_all([['T-VS57']]) }
        .to raise_error('Incorrect line item data at line 1')
    end
  end
end
