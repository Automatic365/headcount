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
      category = :math if category == :math
      category = :reading if category == :reading
      category = :writing if category == :writing
      subjects = [:math, :reading, :writing]

      file = csv

      file_data = CSV.open(file, headers: true, header_converters: :symbol)

      file_data.each do |row|
        name = row[:location].upcase
        subject = row[:score].downcase.to_sym if row.include?(:score)
        year = row[:timeframe].to_i
        percentage = row[:data].to_f
        if row.include?(:race_ethnicity)
          if row[:race_ethnicity] == "Hawaiian/Pacific Islander"
          race = :pacific_islander
          else
          race = row[:race_ethnicity].tr(" ", "_").downcase.to_sym
          end
        end

      if subjects.include?(category) #if category is math, reading, or writing
        if all_data.has_key?(name)  #if all_data contains the district name
          if all_data[name].has_key?(race) #if the district name contains a race
            if all_data[name][race].has_key?(year) #if the race contains a year
              all_data[name][race][year][category] = percentage #set category equal to percentage
            else
              all_data[name][race][year] = {category => percentage} #set year data
            end
          else
            all_data[name][race] = {year => {category => percentage}} #set race data
          end
        else
          all_data[name] = {race => {year => {category => percentage}}} #set district data
        end
      else
        if all_data.has_key?(name) #if all_data contains the district name
          if all_data[name].has_key?(category) #if all_data contains a category
            if all_data[name][category].has_key?(year) #if the category contains a year
              all_data[name][category][year][subject] = percentage #set subject equal to percentage
            else
              all_data[name][category][year] = {subject => percentage} #set year data
            end
          else
            all_data[name][category] = {year => {subject => percentage}} #set category data
          end
        else
          all_data[name] = {category => {year => {subject => percentage}}} #set district data
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


            #{name => district,
            #grade => {year => {subject => percentage}},
            #race => {year => {subject => percentage}}}






end
