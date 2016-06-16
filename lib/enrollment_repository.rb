require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :enrollments, :all_data

  def initialize(enrollments = {})
    @enrollments = enrollments
    @all_data    = {}
  end

  def load_data(data)
    data[:enrollment].each do |school_type, csv|
      school_type = :kindergarten_participation if school_type == :kindergarten
       CSV.foreach(csv, headers: true, header_converters: :symbol) do |row|
        info = parse_row(row)
        compile_data(all_data, school_type, info)
      end
    end
    create_enrollments(all_data)
  end

  def parse_row(row)
    [row[:location].upcase, row[:timeframe].to_i, row[:data].to_f]
  end

  def create_enrollments(data)
    data.each do |name, district_data|
      enrollments.merge!(name => Enrollment.new(district_data))
    end
  end

  def find_by_name(name)
    enrollments[name.upcase]
  end

  def compile_data(all_data, school_type, info)
    name, year, percentage = info
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
