require './test/test_helper'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_enrollment_stores_an_enrollment
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677})
    assert_equal ({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}), e.enrollment
  end

  def test_find_by_name_finds_a_district
    dr = DistrictRepository.new
    
  end


end
