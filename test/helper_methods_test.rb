require './test/test_helper'
require './lib/helper_methods'

class HelperMethodsTest < Minitest::Test
include HelperMethods

  def test_truncates_float
    a = 0.35356
    assert_equal 0.353, truncate_float(a)
  end

end
