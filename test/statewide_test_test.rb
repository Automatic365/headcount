require './test/test_helper'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def test_statewide_test_has_a_name
    swt = StatewideTest.new({name: "Academy 20"})
    assert_equal "ACADEMY 20", swt.name
  end


end
