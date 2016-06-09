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
    assert_equal 2, er.enrollments.count
    result = {2012=>0.88983, 2013=>0.91373}
    assert_equal result, er.enrollments["ACADEMY 20"].attributes[:high_school_graduation]
  end
  # assert_equal ({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}, :high_school_graduation => {2010 = 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898}})


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

  

  # def test_load_data(file_tree)
  #   # {
  #   # :enrollment => {
  #   #   :kindergarten => "./data/Kindergartners in full-day program.csv"
  #   # }
  #   # }
  #
  #   # { :name => "ACADEMY 20",
  #   # :kindergarten_participation => {
  #   #   2010 => 0.3915,
  #   #   2011 => 0.35356,
  #   #   2012 => 0.2677
  #   #   }}
  #   filepath = file_tree[:enrollment][:kindergarten]
  #
    # years = CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
    #   { name: row[:location], row[:timeframe].to_i => row[:data].to_f}
    # end
    #
    # per_enrollment_by_year = years.group_by do |row|
    #   row[:name]
    # end
    #
    # enrollment_data = per_enrollment_by_year.map do |name, years|
    #   merged = years.reduce({}, :merge)
    #   merged.delete(:name)
    #   { name: name,
    #     kindergarten_participation: merged}
    # end
    #
  #
  # # end.map do |name, years|
  # #         merged = years.reduce({}, :merge)
  # #         [name merged]
  # #       end.map |name, kindergarten_data|
  # #       kindergarten_data_data.delete(:name)
  # #       [name, kindgarten_data]
  # #         { name: name,
  # #           kindergarten_participation: kindergarten_data
  # #         }
  # #       end
  #
  #   enrollment_data.each do |e|
  #     @enrollments << Enrollment.new(e)
  #   end
  #
  # end
  #
  # def test_find_by_name
  #   e1 = Enrollment.new({:name => "ACADEMY 20"})
  #   e2 = Enrollment.new({:name => "Pizza academy 30"})
  #   er = EnrollmentRepository.new([e1, e2])
  #   enrollment = er.find_by_name("ACADEMY 20")
  #   assert_equal "ACADEMY 20", enrollment.name
  # end
  #

end
