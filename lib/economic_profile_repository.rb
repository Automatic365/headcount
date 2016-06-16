require_relative 'economic_profile'
require 'csv'

class EconomicProfileRepository

    attr_reader :economic_profiles, :all_data

    def initialize(economic_profiles = {})
      @economic_profiles = economic_profiles
      @all_data = {}
    end

    def load_data(data)
      data[:economic_profile].each do |category, csv|
        CSV.foreach(csv, headers: true, header_converters: :symbol) do |row|
          compile_data(row, category)
        end
      end
      create_economic_profiles(all_data)
    end

    def compile_data(row, category)
      i = parse_row(row).push(category)
      income_data(i) if category == :median_household_income
      lunch_data(i) if category == :free_or_reduced_price_lunch
      misc(i) if category == :title_i || category == :children_in_poverty
    end

    def parse_row(row)
      [row[:location].upcase, row[:dataformat], row[:data], row[:timeframe]]
    end

    def income_data(i)
      name, type, income, timeframe, category = i
      years = timeframe.split("-").map { |year| year.to_i }
      get_other_data(all_data, name, category, years, income.to_i)
    end

    def lunch_data(i)
      name, type, data, year, category = i
      percent = data.to_f
      total = data.to_i
      get_lunch_data(all_data, name, category, year.to_i, percent, total, type)
    end

    def misc(i)
      name, type, percent, year, category = i
      category == :title_i || category == :children_in_poverty
      get_other_data(all_data, name, category, year.to_i, percent.to_f)
    end

    def find_by_name(name)
      economic_profiles[name.upcase]
    end

    def create_economic_profiles(data)
      data.each do |name, district_data|
        economic_profiles.merge!(name => EconomicProfile.new(district_data))
      end
    end

    def get_other_data(data, name, category, time, stats)
      if data[name] && data[name][category]
        data[name][category][time] = stats
      end
      if data[name] && data[name][category].nil?
        data[name][category] = {time => stats}
      end
      if data[name].nil?
        data[name] = {category => {time => stats}}
      end
    end

    def get_lunch_data(data, name, set, yr, prcnt, total, type)
      if data[name] && data[name][set] && data[name][set][yr] && type=="Percent"
        data[name][set][yr][:percentage] = prcnt
      end
      if data[name] && data[name][set] && data[name][set][yr] && type=="Number"
        data[name][set][yr][:total] = total
      end
      if data[name] && data[name][set] && data[name][set][yr].nil?
        data[name][set][yr] = {percentage: prcnt, total: total}
      end
      if data[name] && data[name][set].nil?
        data[name][set] = {yr => {percentage: prcnt, total: total}}
      end
      if data[name].nil?
        data[name] = {set => {yr => {percentage: prcnt, total: total}}}
      end
    end

end
