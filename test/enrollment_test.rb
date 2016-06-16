require './test/test_helper'
require './lib/enrollment'
require './lib/helper_methods'

class EnrollmentTest < Minitest::Test
  include HelperMethods

  def test_enrollment_stores_an_enrollment
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal ({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}), e.attributes
  end

  def test_enrollment_has_a_name
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal "ACADEMY 20", e.name
  end

  def test_truncates_float
    e = Enrollment.new({})
    a = 0.35356
    assert_equal 0.353, e.truncate_float(a)
  end

  def test_kindergarten_participation_by_specific_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    result = {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}
    assert_equal result, e.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_in_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal nil, e.kindergarten_participation_in_year(1990)
    assert_equal 0.391, e.kindergarten_participation_in_year(2010)
  end

  def test_it_can_find_graduation_rate_by_year
    e = Enrollment.new({:name => "ACADEMY 20", :high_school_graduation => { 2010 => 0.895002, 2011 => 0.8950005, 2012 => 0.889002}})
    result = {2010 => 0.895, 2011 => 0.895, 2012 => 0.889}
    assert_equal result, e.graduation_rate_by_year
  end

  def test_it_can_find_graduation_in_specific_year
    e = Enrollment.new({:name => "ACADEMY 20", :high_school_graduation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal nil, e.graduation_rate_in_year(1990)
    assert_equal 0.391, e.graduation_rate_in_year(2010)
  end
  
end
