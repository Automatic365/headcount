require 'minitest/autorun'
require 'minitest/pride'
require './lib/headcount_analyst'
require './lib/district_repository'
require './lib/helper_methods'

class HeadcountAnalystTest < Minitest::Test
  include HelperMethods

  def test_it_can_access_district_by_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample2.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_instance_of District, ha.get_district_by_name("ACADEMY 20")
  end

  def test_it_can_access_enrollment_attributes
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample2.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    d = ha.get_district_by_name("Academy 20")
    result = {2007=>0.39159, 2006=>0.35364}
    assert_equal result, ha.access_enrollment_attributes(d)
  end

  def test_it_can_calculate_district_average
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample2.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_equal 0.372, ha.get_district_average("ACADEMY 20")
  end

  def test_it_can_can_calculate_average_district_participation_rate
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample2.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_equal 1.019, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_it_can_compare_participation_rate_to_state_average
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample2.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    result = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')

    assert_equal 0.75, result
  end

  def test_it_can_compare_participation_rate_to_another_district
    skip
    result = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'Dist 2')
    assert_equal 0.5, result
  end

  def test_it_can_compare_partipation_rate_trend_against_the_state_average
    skip
    result = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'Dist 2')
    assert_equal 0.5, result
  end





end
