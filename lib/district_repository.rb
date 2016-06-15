require 'csv'
require 'pry'
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'

class DistrictRepository
  attr_reader :districts, :er, :str, :epr

  def initialize(districts = {})
    @districts = districts
    @er = EnrollmentRepository.new
    @str = StatewideTestRepository.new
    @epr = EconomicProfileRepository.new
  end

def load_data(data)
  data.each do |category, data_collection|
    if category == :enrollment
      er.load_data(data)
    elsif category == :statewide_testing
      str.load_data(data)
    elsif category == :economic_profile
      epr.load_data(data)
    end
  end
  create_districts
end

  def create_districts
    er.enrollments.keys.each do |name|
      districts[name] = District.new({:name => name}, self)
    end
  end

  def find_enrollment(district_name)
    er.find_by_name(district_name)
  end

  def find_statewide_test(district_name)
    str.find_by_name(district_name)
  end

  def find_economic_profile(district_name)
    epr.find_by_name(district_name)
  end

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


#
#   def load_data(data)
#   data.each do |category, data_collection|
#     if category == :enrollment
#       er.load_data(data)
#       data[:enrollment].each do |data_element, csv|
#         file = csv
#         CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
#           # unless districts.include?(row[:location])
#             name = row[:location].upcase
#             new_enrollment = er.find_by_name(name)
#             d = District.new(name: name)
#             create_new_enrollment(d, new_enrollment)
#             districts.merge!(name => d)
#           # end
#         end
#       end
#     elsif category == :statewide_testing
#       str.load_data(data)
#       data[:statewide_testing].each do |data_element, csv|
#         file = csv
#         CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
#           # unless districts.include?(name)
#             name = row[:location].upcase
#             new_statewide_test = str.find_by_name(name)
#             #if district exists in districts, just use that district
#             d = District.new(name: name)
#             create_new_statewide_test(d, new_statewide_test)
#             districts.merge!(name => d)
#           # end
#         end
#       end
#     elsif category == :economic_profile
#       epr.load_data(data)
#       data[:economic_profile].each do |data_element, csv|
#         file = csv
#         CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
#           name = row[:location].upcase
#           new_economic_profile = epr.find_by_name(name)
#           d = District.new(name: name)
#           create_new_economic_profile(d, new_economic_profile)
#           districts.merge!(name => d)
#         end
#       end
#     end
#   end
# end
