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
  end

  def test_can_find_a_district_by_name
    skip
    dr = DistrictRepository.new
    district = dr.find_by_name("aasasdg")
    assert_equal nil
    district = dr.find_by_name("Academy 20")
    assert_equal "ACADEMY 20"
  end

  def test_can_find_multiple_districts_by_name
    skip
    dr = DistrictRepository.new
    district = dr.find_all_matching("asasfd, asdffew")
    assert_equal []
    district = dr.find_all_matching("Academy 20, Adams County 14")
    assert_equal "ACADEMY 20, ADAMS COUNTY 14"
  end

end
