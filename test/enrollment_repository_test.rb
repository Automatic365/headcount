require './test/test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_loads_data
    er = EnrollmentRepository.new
    assert er.enrollments.empty?
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/sample.csv"
      }
    })
    refute er.enrollments.empty?
    assert_instance_of Enrollment, er.enrollments["ACADEMY 20"]
    assert_equal 2, er.enrollments.count
    result = {2007=>0.39159, 2006=>0.35364}
    assert_equal result, er.enrollments["ACADEMY 20"].attributes[:kindergarten_participation]
  end

  def test_it_can_load_multiple_data_files
    er = EnrollmentRepository.new
    assert er.enrollments.empty?
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/sample.csv",
          :high_school_graduation => "./data/sample_hs.csv"
      }
    })
    assert_instance_of Enrollment, er.enrollments["ACADEMY 20"]
    assert_equal 3, er.enrollments.count
    result = {2012=>0.88983, 2013=>0.91373}
    assert_equal result, er.enrollments["ACADEMY 20"].attributes[:high_school_graduation]
  end

  def test_it_can_create_enrollments
    er = EnrollmentRepository.new
    assert er.enrollments.empty?
    data = {"ACADEMY 20"=> {:name=>"ACADEMY 20", :kindergarten_participation=>{2007=>0.39159, 2006=>0.35364}}}
    er.create_enrollments(data)
    assert 1, er.enrollments.count
    assert_instance_of Enrollment, er.enrollments["ACADEMY 20"]
  end

  def test_find_by_name
    e1 = Enrollment.new({:name => "ACADEMY 20"})
    e2 = Enrollment.new({:name => "cheese"})
    er = EnrollmentRepository.new({e1.name => e1, e2.name => e2})
    enrollment1 = er.find_by_name("Academy 20")
    enrollment2 = er.find_by_name("cheese")
    assert_equal nil, er.find_by_name("alakjhgs")
    assert_equal "ACADEMY 20", enrollment1.name
    assert_equal "CHEESE", enrollment2.name
  end

  def test_parse_row
    er = EnrollmentRepository.new
    row = {location: "cheese", timeframe: 1.0, data: 2}
    result = ["CHEESE", 1, 2.0]
    assert_equal result, er.parse_row(row)
  end

  def test_compile_data
    er = EnrollmentRepository.new
    all_data = {"ACADEMY 20"=>{:name=>"ACADEMY 20", :kindergarten_participation=>{2007=>0.39159}}}
    school_type = :kindergarten_participation
    info = ["ACADEMY 20", 2006, 0.35364]
    er.compile_data(all_data, school_type, info)
    assert_equal 0.35364, all_data["ACADEMY 20"][:kindergarten_participation][2006]
  end

end
