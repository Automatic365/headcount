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

       CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
        name    = row[:location].upcase
        subject = row[:score].downcase.to_sym if row.include?(:score)
        year    = row[:timeframe].to_i

        if row[:data].to_f == 0.0
          percentage = "N/A"
        else
          percentage = row[:data].to_f
        end

        if subjects.include?(category)
          race = row[:race_ethnicity].tr(" ", "_").downcase.to_sym
          race = :pacific_islander if row[:race_ethnicity] == "Hawaiian/Pacific Islander"
          compile_data(all_data, name, race, year, category, percentage)
        else
          compile_data(all_data, name, category, year, subject, percentage)
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

  def compile_data(all_data, name, group, year, set, percentage)
    data = all_data, name, group, year, set, percentage
    all_data[name][group][year][set] = percentage if year_populated?(data)
    all_data[name][group][year][set] = percentage if group_populated?(data)
    all_data[name][group][year][set] = percentage if name_populated?(data)
    all_data[name][group][year][set] = percentage if set_populated?(data)




    all_data[name] && all_data[name][group] && all_data[name][group][year]
      all_data[name][group][year][set] = percentage
    end
    if all_data[name] && all_data[name][group] && all_data[name][group][year].nil?
      all_data[name][group][year] = {set => percentage}
    end
    if all_data[name] && all_data[name][group].nil?
      all_data[name][group] = {year => {set => percentage}}
    end
    if all_data[name].nil?
      all_data[name] = {group => {year => {set => percentage}}}
    end
  end

            #{name => district,
            #grade => {year => {subject => percentage}},
            #race => {year => {subject => percentage}}}






end
