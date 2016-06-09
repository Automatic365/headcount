require_relative 'helper_methods'

class HeadcountAnalyst
  include HelperMethods
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district, comparison)
    d1 = get_district_average(district)
    d2 = get_district_average(comparison[:against])
    truncate_float(d1 / d2)
  end

  def get_district_average(district)
    name = get_district_by_name(district)
    data = access_enrollment_attributes(name)
    avg = calculate_average(data)
    truncate_float(avg)
  end

  def get_district_by_name(name)
    district_repo.find_by_name(name)
  end

  def access_enrollment_attributes(district)
    district.enrollment.attributes[:kindergarten_participation]
  end

  def calculate_average(data)
    data.values.reduce(0, :+) / data.values.count
  end


end
