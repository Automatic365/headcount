require './test/test_helper'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

  def test_loads_data
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    assert_instance_of StatewideTest, str.statewide_tests["ACADEMY 20"]
    assert_equal 181, str.statewide_tests.count
    result1 = {2011=>{:math=>0.8169, :reading=>0.8976, :writing=>0.8268}, 2012=>{:math=>0.8182, :reading=>0.89328, :writing=>0.8083}, 2013=>{:math=>0.8053, :reading=>0.90193, :writing=>0.8109}, 2014=>{:math=>0.8, :reading=>0.85531, :writing=>0.7894}}
    result2 = {2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671}, 2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706}, 2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662}, 2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678}, 2012=>{:reading=>0.87, :math=>0.83, :writing=>0.65517}, 2013=>{:math=>0.8554, :reading=>0.85923, :writing=>0.6687}, 2014=>{:math=>0.8345, :reading=>0.83101, :writing=>0.63942}}
    assert_equal result1, str.statewide_tests["ACADEMY 20"].attributes[:asian]
    assert_equal result2, str.statewide_tests["ACADEMY 20"].attributes[3]

  end

  def test_find_by_name
    st = StatewideTest.new(name: "Academy 20")
    str = StatewideTestRepository.new({st.name => st})
    assert_equal nil, str.find_by_name("asdfklj")
    result = str.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", result.name
  end

  def test_set_category
    sr = StatewideTestRepository.new
    assert_equal nil, sr.set_category(nil)
    assert_equal 8, sr.set_category(:eighth_grade)
  end

  def test_parse_row
    sr = StatewideTestRepository.new
    row = {location: "abc", timeframe: 1.0, data: 0.0}
    assert_equal ["ABC", 1, "N/A"], sr.parse_row(row)
  end

  def test_compile_data
    sr = StatewideTestRepository.new
    row = {location: "ACADEMY 20", score: "Reading", timeframe: "2010", dataformat: "Percent", data: "0.864"}
    sr.compile_data(row, 3)
    assert_equal ({reading: 0.864}), sr.all_data["ACADEMY 20"][3][2010]
  end

  def test_race_data
    sr = StatewideTestRepository.new
    row = {location: "Colorado", race_ethnicity: "All Students", timeframe: "2011", dataformat: "Percent", data: "0.557"}
    info = ["ACADEMY 20", 2011, 0.557]
    sr.race_data(:math, info, row)
    assert_equal ({math: 0.557}), sr.all_data["ACADEMY 20"][:all_students][2011]
  end

  def test_grade_data
    sr = StatewideTestRepository.new
    row = {location: "ACADEMY 20", score: "Reading", timeframe: "2010", dataformat: "Percent", data: "0.864"}
    info = ["ACADEMY 20", 2010, 0.864]
    sr.grade_data(3, info, row)
    assert_equal ({reading: 0.864}), sr.all_data["ACADEMY 20"][3][2010]
  end

  def test_check_for_non_numbers
    sr = StatewideTestRepository.new
    row1 = {data: "0.864"}
    row2 = {data: "0.0"}
    assert_equal 0.864, sr.check_for_non_numbers(row1)
    assert_equal "N/A", sr.check_for_non_numbers(row2)
  end

  def test_generate_data
    sr = StatewideTestRepository.new
    sr.generate_data(sr.all_data, "ACADEMY 20", 3, 2010, :reading, 0.864)
    assert_equal ({reading: 0.864}), sr.all_data["ACADEMY 20"][3][2010]
  end


end
