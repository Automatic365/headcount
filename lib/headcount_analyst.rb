require_relative 'helper_methods'

class HeadcountAnalyst
  include HelperMethods
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district, comparison)
    d1 = get_district_data(district)
    d2 = get_district_data(comparison[:against])
    avg1 = calculate_average(d1)
    avg2 = calculate_average(d2)
    truncate_float(avg1 / avg2)
  end

  def kindergarten_participation_rate_variation_trend(district, comparison)
    data1 = get_district_data(district)
    data2 = get_district_data(comparison[:against])
    averages = data1.merge(data2){ |key, oldval, newval| truncate_float(newval / oldval) }
    end

  def get_district_data(district)
    name = get_district_by_name(district)
    data = access_enrollment_attributes(name)
  end

  def get_district_by_name(name)
    district_repo.find_by_name(name)
  end

  def access_enrollment_attributes(district)
    district.enrollment.attributes[:kindergarten_participation]
  end

  def calculate_average(data)
    data.values.reduce(0, :+) / data.values.count
  end

  def kindergarten_participation_against_high_school_graduation(district)
    # d1 = get_district_data(district)
    dname1 = get_district_by_name(district)
    d1 = dname1.enrollment.attributes[:kindergarten_participation]
    d_avg1 = calculate_average(d1)
    #.372615
    name1 = get_district_by_name("COLORADO")
    state_kdg = name1.enrollment.attributes[:kindergarten_participation]
    state_kdg_avg = calculate_average(state_kdg)
    #.36571
    kdg_variance = d_avg1 / state_kdg_avg
    #1.01888
    dname2 = get_district_by_name(district)
    d2 = dname2.enrollment.attributes[:high_school_graduation]
    d1_avg2 = calculate_average(d2)
    #.90178
    name2 = get_district_by_name("COLORADO")
    state_hs = name2.enrollment.attributes[:high_school_graduation]
    state_avg_hs = calculate_average(state_hs)
    #.74627
    hs_variance = d1_avg2 / state_avg_hs
    #1.208383
    total_variance = kdg_variance / hs_variance
    truncate_float(total_variance)
    #.843176
  #   # want to access the kindergarten participation rates for a district
  #     #get the averagae of these rates
  #     #Divide these rates by statewide average
  #   #Get statewide partipation for kindergarten
  #     #get average
  #   # want to access the high school graduation rates for a district
  #     #get the averagae of these rates
  #     #Divide these rates by statewide average
  #   #Get statewide partipation for highschool
  #     #get average
  #   #Divide kindergarten variation by graduation variation
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district)
    
    #if the key of the argument is 'for'
      #take the value as the argument
      #If the result of kindergarten_participation_against_high_school_graduation(district)
      #is between .6 and 1.5 return true

      #else if the argument is 'statewide'
        #run the previous step for every district1
        #keep track of the number of true and false
        # if the number of true is > 70%, return true


    # if the key of the argument is 'across'
      #loop each district through the method above
      #
  end



end
