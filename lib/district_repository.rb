require 'csv'
require 'pry'
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'

class DistrictRepository
  attr_reader :districts, :er, :st

  def initialize(districts = {})
    @districts = districts
    @er = EnrollmentRepository.new
    @st = StatewideTestRepository.new
  end


  def load_data(data)
    data.each do |category, data_collection|
      if category == :enrollment
        er.load_data(data)
        data[:enrollment].each do |data_element, csv|
          file = csv
          contents = CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
            # unless districts.include?(row[:location])
              name = row[:location].upcase
              new_enrollment = er.find_by_name(name)
              d = District.new(name: name)
              d.enrollment = new_enrollment
              districts.merge!(name => d)
            # end
          end
        end
      elsif category == :statewide_testing
        st.load_data(data)
        data[:statewide_testing].each do |data_element, csv|
          file = csv
          contents = CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
            # unless districts.include?(name)
              name = row[:location].upcase
              new_statewide_test = st.find_by_name(name)
              d = District.new(name: name)
              d.statewide_test = new_statewide_test
              districts.merge!(name => d)
            # end
          end
        end
      end
    end
  end

    #ORIGINAL LOAD DATA METHOD
    # er.load_data(data)
    # data[:enrollment].each do |school_type, csv|
    #   file = csv
    #   contents = CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
    #     # unless districts.include?(row[:location])
    #       new_enrollment = er.find_by_name(row[:location])
    #       d = District.new(name: row[:location].upcase)
    #       d.enrollment = new_enrollment
    #       districts.merge!(row[:location].upcase => d)
    #     # end
    #   end
    # end


#EXPERIMENTAL LOAD DATA METHOD
# def load_data(data)
#   data.each do |category, subcategory|
#     repository = ""
#     if category == :enrollment
#       repository = er
#     elsif category == :statewide_testing
#       repository = st
#     end
#     repository.load_data(data)
#     subcategory.each do |attribute, csv|
#       file = csv
#
#       contents = CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
#         name = row[:location].upcase
#         if districts.include?(name)
#           d = find_by_name(name)
#         else
#           d = create_new_district(name)
#         end
#         new_data = repository.find_by_name(name)
#           if category == :enrollment
#             d.enrollment = new_data
#           elsif category == :statewide_test
#             d.statewide_enrollment = new_data
#           end
#         districts.merge!(name => d)
#       end
#     end
#   end
# end

  def create_new_district(name)
    District.new(name: name)
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
