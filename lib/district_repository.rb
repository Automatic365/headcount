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
    #parse hash
    #{name => {name: District} *** value is district object}
    #   ({
    # :enrollment => {
    #   :kindergarten => "./data/Kindergartners in full-day program.csv"
    #   }
    # })
    #saves csv as file
    file = data[:enrollment][:kindergarten]

    #reads csv file and adds hash containing district pointing to district object
    contents = CSV.open(file, headers: true, header_converters: :symbol)
     contents.each do |row|
      unless districts.keys.include?(row[:location].upcase)
        districts.merge!(row[:location] => District.new(name: row[:location]))
      end
    end


  end

  def find_by_name
  end

  def find_all_matching
  end

end




# dr = DistrictRepository.new
# dr.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# district = dr.find_by_name("ACADEMY 20")
