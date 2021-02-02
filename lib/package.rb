class Package
  InvalidPackage = Class.new(StandardError)

  attr_accessor :size, :price

  def initialize(size, price)
    @size = size
    @price = price

    validate!
  end

  def self.exists?(packages, size)
    return false if packages.nil? && !packages.is_a?(Array)

    packages.any? { |package| package.size == size }
  end

  private

  def validate!
    error = " must be present and should be a valid "

    self.size = Integer(size) rescue raise(
      InvalidPackage.new("Size" + error +  "integer value")
    )

    self.price = Float(price) rescue raise(
      InvalidPackage.new("Price" + error + "float value")
    )
  end
end
