require_relative 'economic_profile'
require 'csv'

class EconomicProfileRepository

    attr_reader :economic_profiles

    def initialize(economic_profiles = {})
      @economic_profiles = economic_profiles
      @all_data = {}
    end

    def load_data(data)
      data[:economic_profile].each do |category, csv|
        CSV.foreach(csv, headers: true, header_converters: :symbol) do |row|
          store_data(category, row)
        end
      end
      create_economic_profiles(all_data)
    end

    def store_data(category, row)
      data = name, dataformat, data, timeframe = [row[:location].upcase, row[:dataformat], row[:data], row[:timeframe]

      method_x(d) if category == :median_household_income
      method_y(d) if category == :y
      method_z(d) if category == :z
      method_a(d) if category == :a
      method_b(d) if category == :b
    end

    def method_x(d)
      name, dataformat, data, timeframe = d[0], d[1], d[2], d[3]
      years = timeframe.split("-").map { |year| year.to_i }
      income = data.to_i
      compile_other_data(all_data, name, category, years, income.to_i)
    end



      case category
      when :median_household_income

      when :free_or_reduced_price_lunch
        year, percent = mhi_year_percent(timeframe, data)
        percent = data.to_f if dataformat == "Percent"
        total = data.to_i if dataformat == "Number"
        compile_lunch_data(all_data, name, category, year, percent, total, dataformat)
      when :title_i # || :children_in_poverty
        year, percent = mhi_year_percent(timeframe, data)
        compile_other_data(all_data, name, category, year, percent.to_f)
      when :children_in_poverty
        year, percent = mhi_year_percent(timeframe, data)
        compile_other_data(all_data, name, category, year, percent.to_f)
      end
    end


    def mhi_year_percent(timeframe, data)
      [timeframe.to_i, data.to_f]
    end

      #name => district
      #{category => {year range => amount}}
      #{category} => {year => percent}
      #{category} => {year => {:percent => percent, :total => total}}
      #{category} => {year => percent}

    def find_by_name(name)
      economic_profiles[name.upcase]
    end

    def create_economic_profiles(data)
      data.each do |name, district_data|
        economic_profiles.merge!(name => EconomicProfile.new(district_data))
      end
    end

    def compile_other_data(all_data, name, category, time, stats)
      if all_data[name] && all_data[name][category]
        all_data[name][category][time] = stats
      end
      if all_data[name] && all_data[name][category].nil?
        all_data[name][category] = {time => stats}
      end
      if all_data[name].nil?
        all_data[name] = {category => {time => stats}}
      end
    end

    def compile_lunch_data(all_data, name, category, year, percent, total, dataformat)
      if all_data[name] && all_data[name][category] && all_data[name][category][year] && dataformat == "Percent"
        all_data[name][category][year][:percentage] = percent
      end
      if all_data[name] && all_data[name][category] && all_data[name][category][year] && dataformat == "Number"
        all_data[name][category][year][:total] = total
      end
      if all_data[name] && all_data[name][category] && all_data[name][category][year].nil?
        all_data[name][category][year] = {:percentage => percent, :total => total}
      end
      if all_data[name] && all_data[name][category].nil?
        all_data[name][category] = {year => {:percentage => percent, :total => total}}
      end
      if all_data[name].nil?
        all_data[name] = {category => {year => {:percentage => percent, :total => total}}}
      end
    end

end
