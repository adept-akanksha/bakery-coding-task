require 'package'

describe Package do
  subject(:package) { described_class }

  describe 'package test general functions' do
    it 'should build package successfully with valid params' do
      expect { package.new('10', '25.99') }
        .to_not raise_exception
    end

    it 'raise exception when size is invalid' do
      expect { package.new('Nine', '25.99') }
        .to raise_error('Size must be present and should be a valid integer value')
    end

    it 'raise exception when size is nil' do
      expect { package.new(nil, '25.99') }
        .to raise_error('Size must be present and should be a valid integer value')
    end

    it 'raise exception when price is invalid' do
      expect { package.new('10', '$25.99') }
        .to raise_error('Price must be present and should be a valid float value')
    end

    it 'raise exception when price is nil' do
      expect { package.new('10', 'nil') }
        .to raise_error('Price must be present and should be a valid float value')
    end
  end

  describe '#exists?' do
    let(:packages) {
      [ package.new(10, 9.99),  package.new(20, 19.99) ]
    }

    it 'should return true when package exists with same size' do
      expect(package.exists?(packages, 10)).to be true
    end

    it 'should return false when package exists with same size' do
      expect(package.exists?(packages, 19)).to be false
    end

    it 'should return false when package are empty' do
      expect(package.exists?([], 19)).to be false
    end

    it 'should return false when package are nil' do
      expect(package.exists?(nil, 19)).to be false
    end
  end
end
