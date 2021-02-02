require 'order'

describe Order do
  subject(:order) { described_class }

  before do
    Bakery.build_products([
      ['Test Vegemite Scroll', 'T-VS5', 5, 8.99],
      ['Test Blueberry Muffin', 'T-MB11', 2, 9.95],
      ['Test Blueberry Muffin', 'T-MB11', 7, 11.99]
    ])
  end

  let(:order_line_items) {
    [
      [20, 'T-VS5'],
      [26, 'T-MB11']
    ]
  }

  describe '#build' do
    it 'builds order successfully when order line items are valid' do
      expect { order.build(order_line_items) }.to_not raise_exception
    end

    it 'raises exception when product code in order is invalid' do
      expect { order.build([[10, 'T-CF-11']]) }
        .to raise_error('Product with code T-CF-11 not found')
    end

    it 'raises exception when line item data is invalid' do
      expect { order.build([['T-CF-11']]) }
        .to raise_error('Incorrect line item data at line 1')
    end

    it 'raises exception when order line items are nil, empty or blank' do
      expect { order.build(nil) }
        .to raise_error('Request could not be serve as no order placed')
      expect { order.build([]) }
        .to raise_error('Request could not be serve as no order placed')
      expect { order.build('') }
        .to raise_error('Request could not be serve as no order placed')
    end
  end

  describe "#total_amount" do
    let(:subject) { order.build(order_line_items).total_amount }

    it { is_expected.to eq(119.64) }
  end
end
