require 'csv'
require './lib/enrollment'

class EnrollmentRepository

  attr_reader :enrollments

  def initialize(enrollments = {})
    @enrollments = enrollments
  end

  def load_data(data)
    file = data[:enrollment][:kindergarten]

    file_data = CSV.open(file, headers: true, header_converters: :symbol)

    all_data = file_data.map do |row|
      { :name => row[:location].upcase, row[:timeframe].to_i => row[:data].to_f  }
      # unless enrollments.keys.include?(row[:location].upcase)
      #   enrollments.merge!(row[:location] => Enrollment.new(name: row[:location], row[:timeframe].to_i => row[:data].to_f))
    end
    enrollment_by_year = all_data.group_by do |row|
      row[:name]
    end

    enrollment_data = enrollment_by_year.map do |name, years|
      merged = years.reduce({}, :merge)
      merged.delete(:name)
      { name: name,
        kindergarten_participation: merged}
    end

    enrollment_data.each do |enrollment|
      enrollments.merge!(enrollment[:name] => Enrollment.new(enrollment))
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

  # def initialize(enrollments = [])
  #   @enrollments = enrollments
  #   #respositories.each do |repo|
  #   # names = repo.collection.amp(&:name)
  #   # repo.collection.amp do |item|
  #   #   item.name
  #   # end.uniq
  #   # @districts = names.map do |name|
  #   #   District.new(name: name)
  # end
  #
  # def load_data(file_tree)
  #
  # end
  #
  # def find_by_name(name)
  #   @enrollments.find do |enrollment|
  #     enrollment[:name] == name
  #   end

end
