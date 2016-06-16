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
  assert_equal 3, dr.districts.count
  end

  def test_can_find_a_district_object_by_name
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
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal 0.391, district.enrollment.kindergarten_participation_in_year(2007)
  end

  def test_can_access_statewide_test_data
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
      :kindergarten => "./data/sample.csv",
      :high_school_graduation => "./data/sample_hs.csv"
    },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_instance_of StatewideTest, district.statewide_test
    result = district.statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
    assert_equal 0.857, result
  end

  def test_can_access_economic_profile_data
    dr = DistrictRepository.new
      dr.load_data( {
        :enrollment => {
          :kindergarten => "./data/Kindergartners in full-day program.csv"
        },
        :economic_profile => {
            :median_household_income => "./data/Median household income.csv",
            :children_in_poverty => "./data/School-aged children in poverty.csv",
            :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
            :title_i => "./data/Title I students.csv"
          }
        })
        district = dr.find_by_name("ACADEMY 20")
        assert_instance_of EconomicProfile, district.economic_profile
        result = district.economic_profile.title_i_in_year(2009)
        assert_equal 0.014, result
  end

  def test_create_districts
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

  def test_find_enrollment
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample.csv"
      }
    })
    e = dr.find_enrollment("ACADEMY 20")
    assert_instance_of Enrollment, e
  end

  def test_find_statewide_test
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/sample.csv"
      }
    })
    st = dr.find_statewide_test("ACADEMY 20")
    assert_instance_of StatewideTest, st
  end

  def test_find_economic_profile
    dr = DistrictRepository.new
    dr.load_data({
      :economic_profile => {
        :title_i => "./data/sample.csv"
      }
    })
    ep = dr.find_economic_profile("ACADEMY 20")
    assert_instance_of EconomicProfile, ep
  end

end
