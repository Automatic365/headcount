require_relative 'statewide_test'
require 'csv'

class StatewideTestRepository

  attr_reader :statewide_tests

  def initialize(statewide_tests = {})
    @statewide_tests = statewide_tests
  end

  def load_data(data)
    all_data = {}
    data[:statewide_testing].each do |category, csv|
      category = 3 if category == :third_grade
      category = 8 if category == :eighth_grade
      subjects = [:math, :reading, :writing]

      file = csv

      contents = CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
        name = row[:location].upcase
        subject = row[:score].downcase.to_sym if row.include?(:score)
        year = row[:timeframe].to_i
        if row[:data].to_f == 0.0
          percentage = "N/A"
        else
          percentage = row[:data].to_f
        end
        if row.include?(:race_ethnicity)
          if row[:race_ethnicity] == "Hawaiian/Pacific Islander"
          race = :pacific_islander
          else
          race = row[:race_ethnicity].tr(" ", "_").downcase.to_sym
          end
        end



# if name_race_year_accounted_for?
#   all_data[name][race][year][category] = percentage #set category equal to percentage
# end

        if subjects.include?(category)
          if all_data[name] && all_data[name][race] && all_data[name][race][year]
            all_data[name][race][year][category] = percentage
          end
          if all_data[name] && all_data[name][race] && all_data[name][race][year].nil?
            all_data[name][race][year] = {category => percentage}
          end
          if all_data[name] && all_data[name][race].nil?
            all_data[name][race] = {year => {category => percentage}}
          end
          if all_data[name].nil?
            all_data[name] = {race => {year => {category => percentage}}}
          end
        else
          if all_data[name] && all_data[name][category] && all_data[name][category][year]
            all_data[name][category][year][subject] = percentage
          end
          if all_data[name] && all_data[name][category] && all_data[name][category][year].nil?
            all_data[name][category][year] = {subject => percentage}
          end
          if all_data[name] && all_data[name][category].nil?
            all_data[name][category] = {year => {subject => percentage}}
          end
          if all_data[name].nil?
            all_data[name] = {category => {year => {subject => percentage}}}
          end
        end
      end
    end
  create_statewide_tests(all_data)
end



  def create_statewide_tests(data)
    data.each do |name, district_data|
      statewide_tests.merge!(name => StatewideTest.new(district_data))
    end
  end

  def find_by_name(name)
    statewide_tests[name.upcase]
  end


            #{name => district,
            #grade => {year => {subject => percentage}},
            #race => {year => {subject => percentage}}}






end
