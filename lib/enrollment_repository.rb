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
      file = csv

      file_data = CSV.open(file, headers: true, header_converters: :symbol)

      file_data.each do |row|
        #if all data includes the name
          #check if the name includes the grade
            #add the year and percentage for that grade
          #else add the grade and the year
      #else ad the name and grade and year
        if all_data.has_key?(row[:location])
          if all_data[row[:location]].has_key?(school_type.to_sym)
            all_data[row[:location]][school_type.to_sym][row[:timeframe].to_i] = row[:data].to_f
          else
            all_data[row[:location]][school_type.to_sym] = {row[:timeframe].to_i => row[:data].to_f}
          end
        else
          all_data[row[:location]] = {:name => row[:location].upcase, school_type.to_sym => {row[:timeframe].to_i => row[:data].to_f}}
        end
      end
    end
    all_data
  end
      #   all_data[row[:location]][school_type.to_sym][row[:timeframe]] = row[:data]
      # end

      # enrollment_by_year = all_data.group_by do |row|
      #   row[:name]

      # all_data
      # assert_equal ({:name => "ACADEMY 20",
      # :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677},
      # :high_school_graduation => {2010 = 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898}})

  # def load_data(data)
  #   array = []
  #   data[:enrollment].each do |school_type, csv|
  #
  #     file = csv
  #
  #     file_data = CSV.open(file, headers: true, header_converters: :symbol)
  #
  #     all_data = file_data.map do |row|
  #       require "pry"; binding.pry
  #       { :name => row[:location].upcase, row[:timeframe].to_i => row[:data].to_f  }
  #       # unless enrollments.keys.include?(row[:location].upcase)
  #       #   enrollments.merge!(row[:location] => Enrollment.new(name: row[:location], row[:timeframe].to_i => row[:data].to_f))
  #     end
  #
  #     enrollment_by_year = all_data.group_by do |row|
  #       row[:name]
  #     end
  #
  #     enrollment_data = enrollment_by_year.map do |name, years|
  #       merged = years.reduce({}, :merge)
  #       merged.delete(:name)
  #       { :name => name,
  #         school_type.to_sym => merged}
  #     end
  #     array << enrollment_data
  #     binding.pry
  #   end
  #
  #     enrollment_data.each do |enrollment|
  #       enrollments.merge!(enrollment[:name] => Enrollment.new(enrollment))
  #     end
  # end

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
