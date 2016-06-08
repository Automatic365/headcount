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

#   def test_loads_districts
#     skip
#     dr = DistrictRepository.new
#     dr.load_data({
#       :enrollment => {
#         :kindergarten => "./data/Kindergartners in full-day program.csv"
#       }
#     })
#     district = dr.find_by_name("ACADEMY 20")
#     assert_equal "ACADEMY 20", district.name
#   end
#
#   def test_find_by_name
#     d1 = District.new(name: "ACADEMY 20")
#     d2 = District.new(name: "PIZZA 30")
#     dr = DistrictRepository.new(name: "([d1, d2])")
#     district = dr.find_by_name("ACADEMY 20")
#     assert_equal "ACADEMY 20", district.name
#   end
#
#   def test_find_all_matching
#   d1 = District.new(name: "ACADEMY 20")
#   d2 = District.new(name: "Horace's school of pizza")
#   d3 = District.new(name: "ACADEMY 30")
#   dr = DistrictRepository.new(name: "([d1, d2, d3])")
#   results = dr.find_all_matching("acadeMy")
#   assert_equal [d1, d3], results
# end
#
#   def test_can_find_a_district_by_name
#     skip
#     dr = DistrictRepository.new
#     district = dr.find_by_name("aasasdg")
#     assert_equal nil
#     district = dr.find_by_name("Academy 20")
#     assert_equal "ACADEMY 20"
#   end
#
#   def test_can_find_multiple_districts_by_name
#     skip
#     dr = DistrictRepository.new
#     district = dr.find_all_matching("asasfd, asdffew")
#     assert_equal []
#     district = dr.find_all_matching("Academy 20, Adams County 14")
#     assert_equal "ACADEMY 20, ADAMS COUNTY 14"
#   end


end
