require './test/test_helper'
require './lib/helper_methods'

class HelperMethodsTest < Minitest::Test
include HelperMethods

  def test_truncates_float
    a = 0.35356
    assert_equal 0.353, truncate_float(a)
  end

  def test_calculate_average
    data = [2, 4, 6]
    assert_equal 4, calculate_average(data)
  end

  def has_year?
    EconomicProfile.new({:title_i => {2015 => 0.543}})
    assert has_year?(:title_i, 2015)
    refute has_year?(:free_or_reduced_price_lunch, 2015)
    Enrollment.new({:kindergarten_participation=>{2007=>0.39159, 2006=>0.35364}})
    assert has_year?(:kindergarten_participation, 2007)
    refute has_year?(:kindergarten_participation, 2001)
  end

end
