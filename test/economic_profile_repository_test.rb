require './test/test_helper'
require './lib/economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test

  def test_loads_data
  epr = EconomicProfileRepository.new
  assert epr.economic_profiles.empty?
  epr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
    }
  })
  refute epr.economic_profiles.empty?
  ep = epr.find_by_name("ACADEMY 20")
  assert_instance_of EconomicProfile, ep
  assert_equal 181, epr.economic_profiles.count
  result_a = {[2005, 2009]=>85060, [2006, 2010]=>85450, [2008, 2012]=>89615, [2007, 2011]=>88099, [2009, 2013]=>89953}
  result_b = {1995=>0.032, 1997=>0.035, 1999=>0.032, 2000=>0.031, 2001=>0.029, 2002=>0.033, 2003=>0.037, 2004=>0.034, 2005=>0.042, 2006=>0.036, 2007=>0.039, 2008=>855.0, 2009=>0.047, 2010=>0.05754, 2011=>0.059, 2012=>0.064, 2013=>0.048}
  result_c = {2009=>0.014, 2011=>0.011, 2012=>0.01072, 2013=>0.01246, 2014=>0.0273}
  result_d = {2014=>{:percentage=>0.08772, :total=>976}, 2012=>{:percentage=>0.12539, :total=>3006}, 2011=>{:percentage=>0.0843, :total=>2834}, 2010=>{:percentage=>0.079, :total=>774}, 2009=>{:percentage=>0.0707, :total=>739}, 2013=>{:percentage=>0.09183, :total=>977}, 2008=>{:percentage=>0.0613, :total=>1343}, 2007=>{:percentage=>0.05, :total=>1071}, 2006=>{:percentage=>0.0416, :total=>653}, 2005=>{:percentage=>0.0587, :total=>1204}, 2004=>{:percentage=>0.0344, :total=>681}, 2003=>{:percentage=>0.03, :total=>435}, 2002=>{:percentage=>0.02722, :total=>396}, 2001=>{:percentage=>0.0247, :total=>407}, 2000=>{:percentage=>0.02, :total=>332}}
  assert_equal result_a, epr.economic_profiles["ACADEMY 20"].attributes[:median_household_income]
  assert_equal result_b, epr.economic_profiles["ACADEMY 20"].attributes[:children_in_poverty]
  assert_equal result_c, epr.economic_profiles["ACADEMY 20"].attributes[:title_i]
  assert_equal result_d, epr.economic_profiles["ACADEMY 20"].attributes[:free_or_reduced_price_lunch]
  end

  def test_find_by_name
    ep = EconomicProfile.new({:name => "ACADEMY 20"})
    epr = EconomicProfileRepository.new({ep.name => ep})
    assert_equal nil, epr.find_by_name("alakjhgs")
    assert_instance_of EconomicProfile, epr.find_by_name("Academy 20")
    assert_equal "ACADEMY 20", epr.find_by_name("Academy 20").name
  end

end
