require 'bakery'
require 'product'

describe Bakery do
  subject(:bakery) { described_class }
  let(:products) {
    [
      ['Test Vegemite Scroll', 'T-VS5', 5, 8.99],
      ['Test Blueberry Muffin', 'T-MB11', 2, 9.95],
      ['Test Blueberry Muffin', 'T-MB11', 7, 9.95]
    ]
  }

  describe '#build_products' do
    context 'builds products successfully' do
      it 'build products successfully if each item is valid' do
        expect { bakery.build_products(products) }.to_not raise_exception
      end

      it 'build products successfully if size is passed in string with correct format' do
        expect {
          bakery.build_products([['Test Blueberry Muffin', 'T-MB11', '7', 9.95]])
        }.to_not raise_exception
      end

      it 'build products successfully if price is passed in string with correct format' do
        expect {
          bakery.build_products([['Test Blueberry Muffin', 'T-MB11', 7, '9.95']])
        }.to_not raise_exception
      end
    end

    context 'raises exception if products data is invalid' do
      let(:invalid_product) { [['Test Vegemite', 5, 8.99]] }
      let(:duplicate_package) { [['Test Vegemite Scroll', 'T-VS5', 5, 8.99]] }
      let(:package_with_invalid_size) { [['Test Vegemite', 'T-VS5', 'Ten', 8.99]] }
      let(:package_with_invalid_price) { [['Test Vegemite Scroll', 'T-VS5', 5, '$8.99']] }

      it 'raises exception if invalid product data is passed' do
        expect { bakery.build_products(invalid_product) }
          .to raise_error("Incorrect product data at line 1")
      end

      it 'does not allow package with same size of same code' do
        expect {
          bakery.build_products(products + duplicate_package)
        }.to raise_error("Package exists with same size")
      end

      it 'raises exception if package size is not in integer format' do
        expect {
          bakery.build_products(package_with_invalid_size)
        }.to raise_error('Size must be present and should be a valid integer value')
      end

      it 'raises exception if package price is not in float format' do
        expect {
          bakery.build_products(package_with_invalid_price)
        }.to raise_error('Price must be present and should be a valid float value')
      end
    end
  end
end
