require_relative 'statewide_test'
require 'csv'

class StatewideTestRepository

  attr_reader :statewide_tests, :all_data

  def initialize(statewide_tests = {})
    @statewide_tests = statewide_tests
    @all_data = {}
  end

  def load_data(data)
    data[:statewide_testing].each do |category, csv|
      category = set_category(category)
       CSV.foreach(csv, headers: true, header_converters: :symbol) do |row|
         compile_data(row, category)
      end
    end
    create_statewide_tests(all_data)
  end

  def set_category(category)
    category = 3 if category == :third_grade
    category = 8 if category == :eighth_grade
    category
  end

  def parse_row(row)
    percentage = check_for_non_numbers(row)
    [row[:location].upcase, row[:timeframe].to_i, percentage]
  end

  def compile_data(row, category)
    subjects = [:math, :reading, :writing]
    info = parse_row(row)
    race_data(category, info, row) if subjects.include?(category)
    grade_data(category, info, row) if !subjects.include?(category)
  end

  def race_data(category, info, row)
    name, year, percentage = info
    r = row[:race_ethnicity].tr(" ", "_").downcase.to_sym
    r = :pacific_islander if row[:race_ethnicity] == "Hawaiian/Pacific Islander"
    generate_data(all_data, name, r, year, category, percentage)
  end

  def grade_data(category, info, row)
    name, year, percentage = info
    subject = row[:score].downcase.to_sym if row.include?(:score)
    generate_data(all_data, name, category, year, subject, percentage)
  end

  def check_for_non_numbers(row)
    percentage = row[:data].to_f
    percentage = "N/A" if row[:data].to_f == 0.0
    percentage
  end

  def create_statewide_tests(data)
    data.each do |name, district_data|
      statewide_tests.merge!(name => StatewideTest.new(district_data))
    end
  end

  def find_by_name(name)
    statewide_tests[name.upcase]
  end

  def generate_data(data, name, group, year, set, percentage)
    if data[name] && data[name][group] && data[name][group][year]
      data[name][group][year][set] = percentage
    end
    if data[name] && data[name][group] && data[name][group][year].nil?
      data[name][group][year] = {set => percentage}
    end
    if data[name] && data[name][group].nil?
      data[name][group] = {year => {set => percentage}}
    end
    if data[name].nil?
      data[name] = {group => {year => {set => percentage}}}
    end
  end

end
