require './test/test_helper'
require './lib/economic_profile'

class EconomicProfileTest < Minitest::Test

  def test_economic_profile_has_a_name
    ep = EconomicProfile.new({name: "Academy 20"})
    assert_equal "ACADEMY 20", ep.name
  end

end
