require './test/test_helper'
require './lib/economic_profile'
require './lib/errors'

class EconomicProfileTest < Minitest::Test

  def test_economic_profile_has_a_name
    ep = EconomicProfile.new({name: "Academy 20"})
    assert_equal "ACADEMY 20", ep.name
  end

  def test_median_household_income_in_year
    ep = EconomicProfile.new({:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000}})
    assert_equal 50000, ep.median_household_income_in_year(2005)
    assert_equal 55000, ep.median_household_income_in_year(2009)
    assert_raises UnknownDataError do
      ep.median_household_income_in_year(1000)
    end
  end

  def test_get_year_ranges
    ep = EconomicProfile.new({:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000}})
    result = {[2005, 2006, 2007, 2008, 2009]=>50000, [2008, 2009, 2010, 2011, 2012, 2013, 2014]=>60000}
    assert_equal result, ep.get_year_ranges
  end

  def test_get_income_in_year
    ep = EconomicProfile.new({:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000}})
    year_ranges = {[2005, 2006, 2007, 2008, 2009]=>50000, [2008, 2009, 2010, 2011, 2012, 2013, 2014]=>60000}
    assert_equal [50000, 60000], ep.check_ranges_for_income_in_year(year_ranges, 2008)
  end

  def test_median_household_income_average
    ep = EconomicProfile.new({:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000}})
    assert_equal 55000, ep.median_household_income_average
  end

  def test_children_in_poverty_in_year
    ep = EconomicProfile.new({:children_in_poverty => {2012 => 0.1845}})
    assert_equal 0.184, ep.children_in_poverty_in_year(2012)
    assert_raises UnknownDataError do
      ep.children_in_poverty_in_year(1000)
    end
  end

  def test_free_or_reduced_price_lunch_percentage_in_year
    ep = EconomicProfile.new({:free_or_reduced_price_lunch => {2014 =>{ :percentage => 0.023, :total => 100}}})
    assert_equal 0.023, ep.free_or_reduced_price_lunch_percentage_in_year(2014)
    assert_raises UnknownDataError do
      ep.free_or_reduced_price_lunch_percentage_in_year(1000)
    end
  end

  def test_free_or_reduced_price_lunch_number_in_year
    ep = EconomicProfile.new({:free_or_reduced_price_lunch => {2014 =>{ :percentage => 0.023, :total => 100}}})
    assert_equal 100, ep.free_or_reduced_price_lunch_number_in_year(2014)
    assert_raises UnknownDataError do
      ep.free_or_reduced_price_lunch_number_in_year(1000)
    end
  end

  def test_title_i_in_year
    ep = EconomicProfile.new({:title_i => {2015 => 0.543}})
    assert_equal 0.543, ep.title_i_in_year(2015)
    assert_raises UnknownDataError do
      ep.title_i_in_year(1000)
    end
  end

  def year_is_valid?
    ep = EconomicProfile.new({:title_i => {2015 => 0.543}})
    assert year_is_valid?(:title_i, 2015)
    refute year_is_valid?(:free_or_reduced_price_lunch, 2015)
  end

end
