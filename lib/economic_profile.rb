require_relative 'helper_methods'
require_relative 'errors'

class EconomicProfile
  include HelperMethods

  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def name
    attributes[:name].upcase
  end

  def median_household_income_in_year(year)
    year_ranges = get_year_ranges
    incomes = check_ranges_for_income_in_year(year_ranges, year)
    if incomes.empty?
      raise UnknownDataError
    else
      calculate_average(incomes)
    end
  end

  def get_year_ranges
    attributes[:median_household_income].keys.reduce({}) do |total_data, years|
      year_range = [*years[0]..years[1]]
      total_data[year_range] = attributes[:median_household_income][years]
      total_data
    end
  end

  def check_ranges_for_income_in_year(year_ranges, year)
    year_ranges.keys.reduce([]) do |all_incomes, year_range|
      all_incomes << year_ranges[year_range] if year_range.include?(year)
      all_incomes
    end
  end

  def median_household_income_average
    calculate_average(attributes[:median_household_income].values)
  end

  def children_in_poverty_in_year(year)
    if year_is_valid?(:children_in_poverty, year)
      truncate_float(attributes[:children_in_poverty][year])
    else
      raise UnknownDataError
    end
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    if year_is_valid?(:free_or_reduced_price_lunch, year)
      truncate_float(attributes[:free_or_reduced_price_lunch][year][:percentage])
    else
      raise UnknownDataError
    end
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    if year_is_valid?(:free_or_reduced_price_lunch, year)
      attributes[:free_or_reduced_price_lunch][year][:total]
      ###Fix truncate float so it works here
    else
      raise UnknownDataError
    end
  end

  def title_i_in_year(year)
    if year_is_valid?(:title_i, year)
      attributes[:title_i][year]
    else
      raise UnknownDataError
    end
  end


end
