module HelperMethods
  def blank?(value)
    value.respond_to?(:empty?) ? (!!value.empty? || value == "nil")  : !value
  end
end
