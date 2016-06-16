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
    @er        = EnrollmentRepository.new
    @str       = StatewideTestRepository.new
    @epr       = EconomicProfileRepository.new
  end

  def load_data(data)
    data.each do |category, data_collection|
      er.load_data(data)  if category == :enrollment
      str.load_data(data) if category == :statewide_testing
      epr.load_data(data) if category == :economic_profile
    end
    create_districts
  end

  def create_districts
    er.enrollments.keys.each do |name|
      districts[name] = District.new({:name => name}, self)
    end
  end

  def find_by_name(name)
    districts[name.upcase]
  end

  def find_all_matching(fragment)
    matching = []
    districts.find_all do |district_name, district|
      matching << district if district_name.include?(fragment.upcase)
    end
    matching
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

end
