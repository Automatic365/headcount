require 'csv'
require 'pry'

class DistrictRespository

  def initialize
    @districts = []
    # @er = EnrollmentRexpository.new
  end

  def find_by_name
  end

  def find_all_matching
  end

  def load_data(hash)
    @hash = hash
  end
end

contents = CSV.open "./data/Kindergartners in full-day program.csv", headers: true, header_converters: :symbol
contents.each do |row|
  location = row[:location]
  timeframe = row[:timeframe]
  data_format = row[:dataformat]
  data = row[:data]
end



# dr = DistrictRepository.new
# dr.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# district = dr.find_by_name("ACADEMY 20")
