require './test/test_helper'
require './lib/statewide_test'
require './lib/errors'

class StatewideTestTest < Minitest::Test

  def test_statewide_test_has_a_name
    swt = StatewideTest.new({name: "Academy 20"})
    assert_equal "ACADEMY 20", swt.name
  end

  def test_proficient_by_grade
    swt = StatewideTest.new({name: "Academy 20", 3 => {2008 => { :math => 0.857, :reading => 0.866, :writing => 0.671}}})
    result = {2008 => { :math => 0.857, :reading => 0.866, :writing => 0.671}}
    assert_equal result, swt.proficient_by_grade(3)
    assert_raises UnknownDataError do
      swt.proficient_by_grade(6)
    end
  end

  def test_proficient_by_race_or_ethnicity
    swt = StatewideTest.new({name: "Academy 20", :pacific_islander => {2008 => { :math => 0.857, :reading => 0.866, :writing => 0.671}}})
    result = {2008 => { :math => 0.857, :reading => 0.866, :writing => 0.671}}
    assert_equal result, swt.proficient_by_race_or_ethnicity(:pacific_islander)
    assert_raises UnknownRaceError do
      swt.proficient_by_race_or_ethnicity(:martian)
    end
  end

  def test_proficient_for_subject_by_grade_in_year
    swt = StatewideTest.new({name: "Academy 20", 3 => {2008 => { :math => 0.857, :reading => 0.866, :writing => 0.671}}})
    assert_equal 0.857, swt.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
    assert_raises UnknownDataError do
      swt.proficient_for_subject_by_grade_in_year(:music, 3, 2008)
    end
    assert_raises UnknownDataError do
      swt.proficient_for_subject_by_grade_in_year(:math, 6, 2008)
    end
  end

  def test_proficient_for_subject_by_race_in_year
    swt = StatewideTest.new({name: "Academy 20", :pacific_islander => {2008 => { :math => 0.857, :reading => 0.866, :writing => 0.671}}})
    assert_equal 0.857, swt.proficient_for_subject_by_race_in_year(:math, :pacific_islander, 2008)
    assert_raises UnknownDataError do
      swt.proficient_for_subject_by_race_in_year(:science, :pacific_islander, 2008)
    end
    assert_raises UnknownDataError do
      swt.proficient_for_subject_by_race_in_year(:math, :martian, 2008)
    end
  end

end
