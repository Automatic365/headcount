require 'csv'
require 'pry'
require_relative 'district'
require_relative 'enrollment_repository'

class DistrictRepository
  attr_reader :districts, :er

  def initialize(districts = {})
    @districts = districts
    @er = EnrollmentRepository.new
  end

  def load_data(data)
    er.load_data(data)

    data[:enrollment].each do |school_type, csv|
      file = csv
      contents = CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
        # unless districts.include?(row[:location])
          new_enrollment = er.find_by_name(row[:location])
          d = District.new(name: row[:location])
          d.enrollment = new_enrollment
          districts.merge!(row[:location].upcase => d)
        # end
      end
    end
  end



  # def load_data(data)
  #
  #   #saves csv as file
  #   file = data[:enrollment][:kindergarten]
  #   er.load_data(data)
  #   #reads csv file and adds hash containing district name pointing to district object
  #   contents = CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
  #     new_enrollment = er.find_by_name(row[:location])
  #     d = District.new(name: row[:location])
  #     d.enrollment = new_enrollment
  #     districts.merge!(row[:location].upcase => d)
  #   end
  # end

  def find_by_name(name)
    districts[name.upcase]
  end

  def find_all_matching(name_fragment)
    found_districts = []
    districts.find_all do |district_name, district_object|
      found_districts << district_object if district_name.include?(name_fragment.upcase)
    end
    found_districts
  end


end
