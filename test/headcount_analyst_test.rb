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
        :kindergarten => "./data/sample_with_statewide_info.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_instance_of District, ha.get_district_by_name("ACADEMY 20")
  end

  def test_it_can_access_enrollment_attributes
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/sample_with_statewide_info.csv"
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
        :kindergarten => "./data/sample_with_statewide_info.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    d = ha.get_district_data("ACADEMY 20")
    assert_equal 0.37261500000000003, ha.calculate_average(d)
  end

  def test_it_can_compare_participation_rate
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

  def test_it_can_compare_participation_rate_trend
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
    skip
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
    # result3 = ha.kindergarten_participation_correlates_with_high_school_graduation(across: ['ACADEMY 20', 'ADAMS COUNTY 14'])
    assert result1
    assert result2
    # assert result3
  end
end
