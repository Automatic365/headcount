require_relative 'economic_profile'
require 'csv'

class EconomicProfileRepository

    attr_reader :economic_profiles

    def initialize(economic_profiles = {})
      @economic_profiles = economic_profiles
    end

    def load_data(data)
      all_data = {}
      data[:economic_profile].each do |category, csv|

        file = csv
        contents = CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
          name = row[:location].upcase
          dataformat = row[:dataformat]
          data = row[:data]
          timeframe = row[:timeframe]

          # name, dataformat, data, timeframe = parse_row(row)
          # #
          # # one, two, three = [1,2,3]
          # def parse_row(row)
          #   [row[:location].upcase, row[:timeframe], row[:data], row[:dataformat]]
          # end

          if category == :free_or_reduced_price_lunch
            if dataformat == "Percent"
              percent = data.to_f
            elsif dataformat == "Number"
              total = data.to_i
            end
          end

          if category == :median_household_income
            years = timeframe.split("-").map { |e| e.to_i }
            income = data.to_i
          else
            year = timeframe.to_i
            percent  = data.to_f
          end

          if category == :free_or_reduced_price_lunch
            compile_lunch_data(all_data, name, category, year, percent, total, dataformat)
          elsif category == :median_household_income
            compile_other_data(all_data, name, category, years, income)
          elsif category == :title_i || category == :children_in_poverty
            compile_other_data(all_data, name, category, year, percent)
          end
        end
      end
      create_economic_profiles(all_data)
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
