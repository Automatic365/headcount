require './test/test_helper'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

  def test_loads_data
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    assert_instance_of StatewideTest, str.statewide_tests["ACADEMY 20"]
    assert_equal 181, str.statewide_tests.count
    result = {2012=>0.88983, 2013=>0.91373}
    require "pry"; binding.pry
    assert_equal result, str.statewide_tests["ACADEMY 20"].attributes["Asian"]
    assert_equal result, str.statewide_tests["ACADEMY 20"].attributes[3]

  end

  def test_find_by_name
    skip
      str = str.find_by_name("ACADEMY 20")
      #returns str object
  end







end
