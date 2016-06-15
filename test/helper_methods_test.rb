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

  def year_is_valid?
    ep = EconomicProfile.new({:title_i => {2015 => 0.543}})
    assert year_is_valid?(:title_i, 2015)
    refute year_is_valid?(:free_or_reduced_price_lunch, 2015)
    e = Enrollment.new({:kindergarten_participation=>{2007=>0.39159, 2006=>0.35364}})
    assert year_is_valid?(:kindergarten_participation, 2007)
    refute year_is_valid?(:kindergarten_pariicipation, 2001)
  end

end
