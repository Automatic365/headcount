require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_loads_data
    dr = DistrictRepository.new
    assert dr.districts.empty?
    dr.load_data({
    :enrollment => {
      :kindergarten => "./data/sample.csv"
    }
  })
  refute dr.districts.empty?
  assert_instance_of District, dr.districts["ACADEMY 20"]
  assert_equal 2, dr.districts.count
  end

  def test_can_find_a_district_object_by_name
    dr = DistrictRepository.new
    # d1 = District.new(name: "ACADEMY 20")
    # d2 = District.new(name: "ADAMS COUNTY")
    # x = d1.district.merge(d2.district)
    # dr = DistrictRepository.new(x)
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample.csv"
      }
    })
    district = dr.find_by_name("asasdg")
    assert_equal nil, district
    district = dr.find_by_name("Academy 20")
    assert_instance_of District, district
  end

  def test_can_find_multiple_districts_by_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample.csv"
      }
    })
    d = dr.find_all_matching("asasfd")
    assert_equal [], d
    d = dr.find_all_matching("Aca")
    assert d[0].kind_of?(District)
    assert_equal 1, d.count
  end

end
