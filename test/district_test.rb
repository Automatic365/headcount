require './test/test_helper'
require './lib/district'

class DistrictTest < Minitest::Test

  def test_district_stores_a_district
    d = District.new(name: "ACADEMY 20")
    assert_equal ({name: "ACADEMY 20"}), d.attributes
  end

  def test_district_has_a_uppercase_name
    d = District.new(name: "ACADEMY 20")
    assert_equal "ACADEMY 20", d.name
  end

end
