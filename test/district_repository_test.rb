require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_loads_data
    dr = DistrictRepository.new
    assert dr.districts.empty?
    dr.load_data({
    :enrollment => {
      :kindergarten => "./data/sample.csv",
      :high_school_graduation => "./data/sample_hs.csv"
    }
  })
  refute dr.districts.empty?
  assert_instance_of District, dr.districts["ACADEMY 20"]
  assert_equal 2, dr.districts.count
  end

  def test_can_find_a_district_object_by_name
    skip
    d1 = District.new(name: "Academy 20")
    d2 = District.new(name: "ADAMS COUNTY")
    dr = DistrictRepository.new({d1.name => d1, d2.name => d2})
    assert_equal nil, dr.find_by_name("asdfklj")
    district1 = dr.find_by_name("Academy 20")
    district2 = dr.find_by_name("Adams County")
    assert_equal "ACADEMY 20", district1.name
    assert_equal "ADAMS COUNTY", district2.name
  end

  def test_can_find_multiple_districts_by_name
    skip
    d1 = District.new(name: "ACADEMY 20")
    d2 = District.new(name: "Academy 30")
    dr = DistrictRepository.new({d1.name => d1, d2.name => d2})


    d = dr.find_all_matching("asasfd")
    assert_equal [], d
    d = dr.find_all_matching("Aca")
    assert_equal "ACADEMY 20", d[0].name
    assert_equal "ACADEMY 30", d[1].name
    assert_equal 2, d.count
  end

  def test_can_access_enrollment_data
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal 0.391, district.enrollment.kindergarten_participation_in_year(2007)
  end

end
