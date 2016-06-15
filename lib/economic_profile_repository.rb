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
          require "pry"; binding.pry
          name = row[:location].upcase
          dataformat = row[:dataformat]
          data = row[:data]
          timeframe = row[:timeframe]

          name, dataformat, data, timeframe = parse_row(row)
          #
          # one, two, three = [1,2,3]
          def parse_row(row)
            [row[:location].upcase, row[:timeframe], row[:data], row[:dataformat]]
          end



          if category == :free_or_reduced_price_lunch
            if dataformat == "Percent"
              percentage = data.to_f
            elsif dataformat == "Number"
              total = data.to_i
            end
          end

          if category == :median_household_income
            years = timeframe.split("-").map { |e| e.to_i }
            income = data.to_i
          else
            year = timeframe.to_i
            percentage  = data.to_f
          end



          if category == :free_or_reduced_price_lunch
              if all_data.has_key?(name)
                if all_data[name].has_key?(category)
                  if all_data[name][category].has_key?(year)
                    if dataformat == "Percent"
                      all_data[name][category][year][:percentage] = percentage
                    else
                      all_data[name][category][year][:total] = total
                    end
                  else
                    all_data[name][category][year] = {:percentage => percentage, :total => total}
                  end
                else
                  all_data[name][category] = {year => {:percentage => percentage, :total => total}}
                end
              else
                all_data[name] = {category => {year => {:percentage => percentage, :total => total}}}
              end
          # elsif dataformat == "Number"
          #     if all_data.has_key?(name)
          #       if all_data[name].has_key?(category)
          #         if all_data[name][category].has_key?(year)
          #           all_data[name][category][year][:total] = total
          #         else
          #           all_data[name][category][year] = {:total => total}
          #         end
          #       else
          #         all_data[name][category] = {year => {:total => total}}
          #       end
          #     else
          #       all_data[name] = {category => {year => {:total => total}}}
          #     end
          #   end

          
          elsif category == :median_household_income
            if all_data.has_key?(name)
              if all_data[name].has_key?(category)
                all_data[name][category][years] = income
              else
                all_data[name][category] = {years => income}
              end
            else
              all_data[name] = {category => {years => income}}
            end
          else
            if all_data.has_key?(name)
              if all_data[name].has_key?(category)
                all_data[name][category][year] = percentage
              else
                all_data[name][category] = {year => percentage}
              end
            else
              all_data[name] = {category => {year => percentage}}
            end
          end
        end
        create_economic_profiles(all_data)
      end
      #name => district
      #{category => {year range => amount}}
      #{category} => {year => percentage}
      #{category} => {year => {:percentage => percentage, :total => total}}
      #{category} => {year => percentage}
    end

    def find_by_name(name)
      economic_profiles[name.upcase]
    end

    def create_economic_profiles(data)
      data.each do |name, district_data|
        economic_profiles.merge!(name => EconomicProfile.new(district_data))
      end
    end


end
