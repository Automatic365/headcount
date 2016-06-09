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

  #When districtrepo initializes, creates new EnrollmentRepository
  #enrollment repo load data takes in samne argument as load data
  #

  def load_data(data)

    #saves csv as file
    file = data[:enrollment][:kindergarten]
    er.load_data(data)
    #reads csv file and adds hash containing district name pointing to district object
    contents = CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
      new_enrollment = er.find_by_name(row[:location])
      d = District.new(name: row[:location])
      d.enrollment = new_enrollment
      districts.merge!(row[:location].upcase => d)
    end
  end

def find_by_name(name)
  found_district = nil
  districts.find do |district_name, district_object|
    found_district = district_object if district_name == name.upcase
  end
  found_district
  #searches districts hash for object
  #returns district object
end

def find_all_matching(name_fragment)
  found_districts = []
  districts.find_all do |district_name, district_object|
    found_districts << district_object if district_name.include?(name_fragment.upcase)
  end
  found_districts
end
#
# def intialize(districts = [])
#   @districts = districts
# end
#
# def find_by_name(name)
#   @districts.find do |district|
#     district.name == name
#   end
# end
#
# def find_all_matching(fragment)
#   @districts.select do |district|
#     district.name.downcase.include?(fragment)
#   end
# end

end
