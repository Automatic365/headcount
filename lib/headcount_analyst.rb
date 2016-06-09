require_relative 'helper_methods'

class HeadcountAnalyst
  include HelperMethods
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district, comparison)
    d1 = get_district_data(district)
    d2 = get_district_data(comparison[:against])
    avg1 = calculate_average(d1)
    avg2 = calculate_average(d2)
    truncate_float(avg1 / avg2)
  end

  def kindergarten_participation_rate_variation_trend(district, comparison)

    data1 = get_district_data(district)
    data2 = get_district_data(comparison[:against])
    averages = data1.merge(data2){ |key, oldval, newval| truncate_float(newval / oldval) }
    end

  def get_district_data(district)
    name = get_district_by_name(district)
    data = access_enrollment_attributes(name)
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
