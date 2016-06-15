require 'test_helper'
require './lib/headcount_analyst'
require './lib/district_repository'
require './lib/helper_methods'
require './lib/errors'
require './lib/economic_profile_repository'

class HeadcountAnalystTest < Minitest::Test
  include HelperMethods

  def test_access_district_by_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample_with_statewide_info.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_instance_of District, ha.get_district_by_name("ACADEMY 20")
  end

  def test_access_enrollment_attributes
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample_with_statewide_info.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    d = ha.get_district_by_name("Academy 20")
    result = {2007=>0.39159, 2006=>0.35364}
    assert_equal result, ha.access_enrollment_attributes(d, :kindergarten_participation)
  end

  def test_calculate_average
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample_with_statewide_info.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    d = ha.get_district_data("ACADEMY 20", :kindergarten_participation)
    assert_equal 0.37261500000000003, ha.calculate_average(d.values)
  end

  def test_get_average_for_attribute
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample_with_statewide_info.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    district = "ACADEMY 20"
    school_type = :kindergarten_participation
    assert_equal 0.37261500000000003, ha.get_average_for_attribute(district, school_type)
  end

  def test_calculate_variance
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    district_avg = 10.0
    state_avg = 20.0
    assert_equal 0.5, ha.calculate_variance(district_avg, state_avg)
  end

  def test_compare_participation_rate
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample_with_statewide_info.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_equal 1.018, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 1.242, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')
  end

  def test_calculate_variance_for_attribute_against_state
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample_with_statewide_info.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    district = "Academy 20"
    school_type = :kindergarten_participation
    assert_equal 1.0188810806376638, ha.calculate_variance_for_attribute_against_state(district, school_type)
  end

  def test_compare_participation_rate_trend
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample_with_statewide_info.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    result = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
    assert_equal ({2007=>1.007, 2006=>0.952}), result
  end

  def test_kindergarten_participation_rate_against_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({
          :enrollment => {
            :kindergarten => "./data/sample_with_statewide_info.csv",
              :high_school_graduation => "./data/sample_hs.csv"
          }})
    ha = HeadcountAnalyst.new(dr)
    result = ha.kindergarten_participation_against_high_school_graduation("ACADEMY 20")
    assert_equal 0.843, result
  end

  def test_correlation_trend_exists?
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    assert ha.correlation_trend_exists?(0.9)
    refute ha.correlation_trend_exists?(0.5)
  end

  def test_is_correlated?
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    assert ha.is_correlated?(0.9)
    refute ha.is_correlated?(1.8)
  end

  def test_count_positive_correlation
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    correlations = [true, false, true]
    assert_equal 2, ha.count_positive_correlations(correlations)
  end

  def test_find_correlations
    dr = DistrictRepository.new
    dr.load_data({
          :enrollment => {
            :kindergarten => "./data/sample_with_statewide_info.csv",
              :high_school_graduation => "./data/sample_hs.csv"
          }})
    ha = HeadcountAnalyst.new(dr)
    districts = dr.districts.reject { |district| district == "COLORADO"}
    correlations = [true, true]
    assert_equal correlations, ha.find_correlations(districts.keys)
  end

  def test_check_for_correlation_trend
    dr = DistrictRepository.new
    dr.load_data({
          :enrollment => {
            :kindergarten => "./data/sample_with_statewide_info.csv",
              :high_school_graduation => "./data/sample_hs.csv"
          }})
    ha = HeadcountAnalyst.new(dr)
    assert ha.check_for_correlation_trend(dr.districts.keys)
  end

  def test_omit_statewide_data
    dr = DistrictRepository.new
    dr.load_data({
          :enrollment => {
            :kindergarten => "./data/sample_with_statewide_info.csv",
              :high_school_graduation => "./data/sample_hs.csv"
          }})
    ha = HeadcountAnalyst.new(dr)
    district_names = ha.omit_statewide_data(dr.districts)
    refute district_names.keys.include?("COLORADO")
  end

  def test_check_for_single_correlation
    dr = DistrictRepository.new
    dr.load_data({
          :enrollment => {
            :kindergarten => "./data/sample_with_statewide_info.csv",
              :high_school_graduation => "./data/sample_hs.csv"
          }})
    ha = HeadcountAnalyst.new(dr)
    assert ha.check_for_single_correlation("Academy 20")
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({
          :enrollment => {
            :kindergarten => "./data/sample_with_statewide_info.csv",
              :high_school_graduation => "./data/sample_hs.csv"
          }})
    # d1 = District.new(name: "ACADEMY 20")
    # dr = DistrictRepository.new({d1.name => d1})
    # e1 = Enrollment.new({"ACADEMY 20"=> {:name=>"ACADEMY 20", :kindergarten_participation=>{2007=>0.39159}, :high_school_participation=>{2007=>NaN}}}
    # er = EnrollmentRepository.new({e1.name => e1})
    ha = HeadcountAnalyst.new(dr)
    result1 = ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'Academy 20')
    result2 = ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')
    result3 = ha.kindergarten_participation_correlates_with_high_school_graduation(across: ['ACADEMY 20', 'ADAMS COUNTY 14'])
    assert result1
    assert result2
    assert result3
  end

  def test_top_statewide_test_year_over_year_growth
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    result1 = ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    result2 = ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
    result3 = ha.top_statewide_test_year_over_year_growth(grade: 3)
    result4 = ha.top_statewide_test_year_over_year_growth(grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
    assert_raises InsufficientInformationError do
      ha.top_statewide_test_year_over_year_growth(subject: :math)
    end
    assert_raises UnknownDataError do
      ha.top_statewide_test_year_over_year_growth(grade: 13, subject: :math)
    end
    assert_equal ["WILEY RE-13 JT", 0.3], result1
    assert_equal [["WILEY RE-13 JT", 0.3], ["SANGRE DE CRISTO RE-22J", 0.071], ["COTOPAXI RE-3", 0.07]], result2
    assert_equal ["SANGRE DE CRISTO RE-22J", 0.071], result3
    assert_equal ["OURAY R-1", 0.153], result4
  end
end
