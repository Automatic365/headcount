require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize(enrollments = {})
    @enrollments = enrollments
  end

  def load_data(data)
    all_data = {}
    data[:enrollment].each do |school_type, csv|
      school_type = :kindergarten_participation if school_type == :kindergarten
      file = csv

      file_data = CSV.open(file, headers: true, header_converters: :symbol)

      file_data.each do |row|
        name = row[:location].upcase
        year = row[:timeframe].to_i
        percentage = row[:data].to_f

        compile_data(all_data, name, school_type, year, percentage)
      end
    end
    create_enrollments(all_data)
  end

  def create_enrollments(data)
    data.each do |name, district_data|
      enrollments.merge!(name => Enrollment.new(district_data))
    end
  end

  def find_by_name(name)
    enrollments[name.upcase]
  end

  def compile_data(all_data, name, school_type, year, percentage)
    if all_data[name] && all_data[name][school_type]
      all_data[name][school_type][year] = percentage
    end
    if all_data[name] && all_data[name][school_type].nil?
      all_data[name][school_type] = {year => percentage}
    end
    if all_data[name].nil?
      all_data[name] = {:name => name, school_type => {year => percentage}}
    end

  end

end
