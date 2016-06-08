require 'csv'
require 'pry'

class DistrictRespository

  def intialize(districts = [])
    @districts = districts
  end

  def find_by_name(name)
    @districts.find do |district|
      district.name == name
    end
  end

  def find_all_matching(fragment)
    @districts.select do |district|
      district.name.downcase.include?(fragment)
    end
  end


end
#   def initialize
#     @districts = []
#     # @er = EnrollmentRexpository.new
#   end
#
#   def find_by_name
#   end
#
#   def find_all_matching
#   end
#
#   def load_data(hash)
#     @hash = hash
#   end
# end
#
# contents = CSV.open "./data/Kindergartners in full-day program.csv", headers: true, header_converters: :symbol
# contents.each do |row|
#   location = row[:location]
#   timeframe = row[:timeframe]
#   data_format = row[:dataformat]
#   data = row[:data]
# end



# dr = DistrictRepository.new
# dr.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# district = dr.find_by_name("ACADEMY 20")
