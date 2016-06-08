require './test/test_helper'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_enrollment_stores_an_enrollment
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal ({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}), e.attributes
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
  #
  # def test_kindergarten_participation_by_specific_year
  #   e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
  #   result = { 2010 => 0.391,
  #    2011 => 0.353,
  #    2012 => 0.267, }
  #    assert_equal result, e.kindergarten_participation_by_year
  # end
  #
  # def test_truncates_float
  #   e = Enrollment.new({})
  #   assert_equal 1.234, e.truncate_float()
  # end
  #
  # def test_kindergarten_participation_in_year(year)
  #   # truncate_float(attributes[:kindergarten_participation][year])
  #   kindergarten_participation_by_year[year]
  # end
  #
  # # def test_find_by_name_finds_a_district
  # #   dr = DistrictRepository.new
  # #
  # # end


end
