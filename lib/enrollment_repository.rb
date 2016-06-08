require 'csv'
require './lib/enrollment'

class EnrollmentRepository

  attr_reader :enrollments

  def initialize(enrollments = {})
    @enrollments = enrollments
  end
  # er = EnrollmentRepository.new
  # er.load_data({
  #   :enrollment => {
  #     :kindergarten => "./data/Kindergartners in full-day program.csv"
  #   }
  # })
  # enrollment = er.find_by_name("ACADEMY 20")
  # => <Enrollment>

  def load_data(data)
    file = data[:enrollment][:kindergarten]

    contents = CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
      unless enrollments.keys.include?(row[:location].upcase)
        enrollments.merge!(row[:location] => Enrollment.new(name: row[:location], row[:timeframe].to_i => row[:data].to_f))
      end

      
    end
  end


  def find_by_name(name)
    found_enrollment = nil
    enrollments.find do |enrollment_name, enrollment_object|
      found_enrollment = enrollment_object if enrollment_name == name.upcase
    end
    found_enrollment
    #searches districts hash for object
    #returns district object
  end

end
