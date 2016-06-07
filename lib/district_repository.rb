require 'csv'
require 'pry'
require './lib/district'

class DistrictRepository

  attr_reader :districts

  def initialize
    @districts = {}
    # @er = EnrollmentRexpository.new
  end

  def load_data(data)

    #saves csv as file
    file = data[:enrollment][:kindergarten]

    #reads csv file and adds hash containing district name pointing to district object
    contents = CSV.open(file, headers: true, header_converters: :symbol)
    contents.each do |row|
      unless districts.keys.include?(row[:location].upcase)
        districts.merge!(row[:location] => District.new(name: row[:location]))
      end
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


end




# dr = DistrictRepository.new
# dr.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# district = dr.find_by_name("ACADEMY 20")
