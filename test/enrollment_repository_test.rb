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
  end

end
