module DetailsBuilder
  def get_package_details(packages, quantity, bunch = [], result = [])
    return find_bunch_with_minmum_packages(bunch, result) if quantity == 0

    packages.each do |package|
      if quantity >= package.size
        new_bunch = bunch.dup.push(package)
        result = get_package_details(packages, quantity - package.size, new_bunch, result)
      end
    end

    result
  end

  private

  def find_bunch_with_minmum_packages(new_bunch, bunch)
    return new_bunch if bunch.empty?
    new_bunch.length < bunch.length ? new_bunch : bunch
  end
end
