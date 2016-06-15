require './test/test_helper'
require './lib/district'

class DistrictTest < Minitest::Test

  def test_district_stores_a_district
    d = District.new(name: "ACADEMY 20")
    assert_equal ({name: "ACADEMY 20"}), d.attributes
  end

  def test_district_has_a_uppercase_name
    d = District.new(name: "ACADEMY 20")
    assert_equal "ACADEMY 20", d.name
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

end
