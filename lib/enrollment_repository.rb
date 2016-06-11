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
        if all_data.has_key?(row[:location].upcase)
          if all_data[row[:location].upcase].has_key?(school_type)
            all_data[row[:location].upcase][school_type][row[:timeframe].to_i] = row[:data].to_f
          else
            all_data[row[:location].upcase][school_type] = {row[:timeframe].to_i => row[:data].to_f}
          end
        else
          all_data[row[:location].upcase] = {:name => row[:location].upcase, school_type => {row[:timeframe].to_i => row[:data].to_f}}
        end
      end
    end
    create_enrollments(all_data)
  end

  def create_enrollments(data)
    data.each do |name, district_data|
      enrollments.merge!(name => Enrollment.new(district_data))
    end
  end

      # all_data
      # assert_equal ({:name => "ACADEMY 20",
      # :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677},
      # :high_school_graduation => {2010 = 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898}})


  # def load_data(data)
  #   file = data[:enrollment][:kindergarten]
  #
  #   file_data = CSV.open(file, headers: true, header_converters: :symbol)
  #
  #   all_data = file_data.map do |row|
  #     { :name => row[:location].upcase, row[:timeframe].to_i => row[:data].to_f  }
  #     # unless enrollments.keys.include?(row[:location].upcase)
  #     #   enrollments.merge!(row[:location] => Enrollment.new(name: row[:location], row[:timeframe].to_i => row[:data].to_f))
  #   end
  #
  #   enrollment_by_year = all_data.group_by do |row|
  #     row[:name]
  #   end
  #   enrollment_data = enrollment_by_year.map do |name, years|
  #     merged = years.reduce({}, :merge)
  #     merged.delete(:name)
  #     { name: name,
  #       kindergarten_participation: merged}
  #   end
  #
  #   enrollment_data.each do |enrollment|
  #     enrollments.merge!(enrollment[:name] => Enrollment.new(enrollment))
  #   end
  # end

  def find_by_name(name)
    enrollments[name.upcase]
  end

end
