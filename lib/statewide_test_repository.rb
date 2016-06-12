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
      grade = :math if category == :math
      grade = :reading if category == :reading
      grade = :writing if category == :writing
      subjects = [:math, :reading, :writing]

      file = csv

      file_data = CSV.open(file, headers: true, header_converters: :symbol)

      file_data.each do |row|
        name = row[:location].upcase
        subject = row[:score].to_sym if row.include?(:score)
        year = row[:timeframe].to_i
        percentage = row[:data].to_f
        race = row[:race_ethnicity].to_sym if row.include?(:race_ethnicity)

      if subjects.include?(category) #if category is math, reading, or writing
        if all_data.has_key?(name)  #if all_data contains the district name
          if all_data[name].has_key?(race) #if the district name contains a race
            if all_data[name][race].has_key?(year) #if the race contains a year
              if all_data[name][race][year].has_key?(subject) #if the year contains a subject
                all_data[name][race][year][subject] = percentage #set subject equal to percentage
              end
            else
              all_data[name][race][year] = {subject => percentage} #set year data
            end
          else
            all_data[name][race] = {year => {subject => percentage}} #set race data
          end
        else
          all_data[name] = {race => {year => {subject => percentage}}} #set district data
        end
      else
        if all_data.has_key?(name) #if all_data contains the district name
          if all_data[name].has_key?(grade) #if all_data contains a grade
            if all_data[name][grade].has_key?(year) #if the grade contains a year
              if all_data[name][grade][year].has_key?(subject) #if the year contains a subject
                all_data[name][grade][year][subject] = percentage #set subject equal to percentage
              end
            else
              all_data[name][grade][year] = {subject => percentage} #set year data
            end
          else
            all_data[name][grade] = {year => {subject => percentage}} #set grade data
          end
        else
          all_data[name] = {grade => {year => {subject => percentage}}} #set district data
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
