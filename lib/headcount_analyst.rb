require_relative 'helper_methods'
require_relative 'errors'

class HeadcountAnalyst
  include HelperMethods
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district, comparison)
    avg1 = get_average_for_attribute(district, :kindergarten_participation)
    avg2 = get_average_for_attribute(comparison[:against], :kindergarten_participation)
    truncate_float(avg1 / avg2)
  end

  def kindergarten_participation_rate_variation_trend(district, comparison)
    data1 = get_district_data(district, :kindergarten_participation)
    data2 = get_district_data(comparison[:against], :kindergarten_participation)
    averages = data1.merge(data2){ |key, oldval, newval| truncate_float(newval / oldval) }
  end

  def get_district_data(district, school_type)
    name = get_district_by_name(district)
    data = access_enrollment_attributes(name, school_type)
  end

  def get_district_by_name(name)
    district_repo.find_by_name(name)
  end

  def access_enrollment_attributes(district, school_type)
    district.enrollment.attributes[school_type]
  end

  def get_average_for_attribute(district, school_type)
    d = get_district_data(district, school_type)
    calculate_average(d.values)
  end

  def calculate_variance(district_avg, state_avg)
    district_avg / state_avg
  end

  def calculate_variance_for_attribute_against_state(district, school_type)
    d_kdg = get_average_for_attribute(district, school_type)
    state_kdg = get_average_for_attribute("Colorado", school_type)
    kdg_variance = calculate_variance(d_kdg, state_kdg)
  end

  def kindergarten_participation_against_high_school_graduation(district)
    # d1 = get_district_data(district)
    #academy 20 kindgarten.372615
    #state kindergarten.36571
    kdg_variance = calculate_variance_for_attribute_against_state(district, :kindergarten_participation)
    #kindergarten variance1.01888
    #academt 20 kindergarten .90178
    #state kindergarten .74627
    hs_variance = calculate_variance_for_attribute_against_state(district, :high_school_graduation)
    #high school variance 1.208383
    total_variance = calculate_variance(kdg_variance, hs_variance)
    truncate_float(total_variance)
    #total variance .843176
  end

  def correlation_trend_exists?(percentage)
    percentage >= 0.7
  end

  def is_correlated?(variance)
    variance >= 0.6 && variance <= 1.5
  end

  def count_positive_correlations(correlations)
    correlations.reduce(0) do |sum, correlation|
      sum += 1 if correlation == true
      sum
    end
  end

  def find_correlations(districts)
    districts.reduce([]) do |data, name|
      variance = kindergarten_participation_against_high_school_graduation(name)
      data << true if is_correlated?(variance)
      data << false if !is_correlated?(variance)
      data
    end
  end

  def check_for_correlation_trend(district_names)
    correlations = find_correlations(district_names)
    total = correlations.count
    positive_correlations = count_positive_correlations(correlations)
    percentage = positive_correlations / total
    correlation_trend_exists?(percentage)
  end

  def check_for_single_correlation(name)
    variance = kindergarten_participation_against_high_school_graduation(name)
    is_correlated?(variance)
  end

  def omit_statewide_data(districts)
    districts.reject { |district| district == "COLORADO"}
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district)
    if district.keys[0] == :for
      name = district[:for].upcase
      if name == "STATEWIDE"
        district_names = omit_statewide_data(district_repo.districts)
        check_for_correlation_trend(district_names.keys)
      else
        check_for_single_correlation(name)
      end
    elsif district.keys[0] == :across
        check_for_correlation_trend(district[:across])
    end
  end

  def top_statewide_test_year_over_year_growth(input)
    #EXCLUDE COLORADO FROM DISTRICTS
    grade = input[:grade]
    subject = input[:subject]
    number_of_districts = input[:top]
    number_of_districts = 1 if number_of_districts.nil?
    weighting = input[:weighting]
    if weighting.nil?
      weighting = {}
      weighting[:math] = 1.0
      weighting[:reading] = 1.0
      weighting[:writing] = 1.0
    end

    if grade.nil?
      raise InsufficientInformationError
    elsif ![3, 8].include?(grade)
      raise UnknownDataError
    elsif subject.nil?
      if input[:weighting].nil?
        get_top_district_growth_for_all_subjects(grade, number_of_districts, weighting)
      else
        get_top_district_growth_for_all_subjects(grade, number_of_districts, weighting)
      end
    else
        get_top_district_growth_for_one_subject(grade, subject, number_of_districts, weighting[subject])
    end
  end

  def get_top_district_growth_for_all_subjects(grade, number_of_districts, weighting)
    math = define_subject_growth_for_districts(grade, :math, weighting[:math]) #.071
    reading = define_subject_growth_for_districts(grade, :reading, weighting[:reading]) #.071
    writing = define_subject_growth_for_districts(grade, :writing, weighting[:writing]) #.071
    math_and_writing = math.merge(writing) { |key, oldval, newval| [oldval] + [newval] }
    district_proficiencies = math_and_writing.merge(reading) { |key, oldval, newval| ([oldval] + [newval]).flatten(1) }
    proficiencies = district_proficiencies.select do |name, percentage|
      percentage.is_a? Array || percentage.count == 3
    end
    d = calculate_average_proficiencies(proficiencies, weighting)
    sorted_proficiencies = sort_districts_by_proficiency(d)
    get_top_districts(sorted_proficiencies, number_of_districts)
  end

  def calculate_average_proficiencies(proficiencies, weighting)
    if is_weighted?(weighting)
      calculate_by_weight(proficiencies, weighting, 1.0)
    else
      calculate_by_weight(proficiencies, weighting, 3.0)
    end
  end

  def is_weighted?(weighting)
    weighting.values.reduce(:+) == 1.0
  end

  def calculate_by_weight(proficiencies, weighting, number)
    proficiencies.each do |key, value|
      proficiencies[key] = value.reduce(:+) / number
    end
  end

  def get_top_district_growth_for_one_subject(grade, subject, number_of_districts, weighting)
    district_proficiencies = define_subject_growth_for_districts(grade, subject, weighting)
    sorted_proficiencies = sort_districts_by_proficiency(district_proficiencies)
    get_top_districts(sorted_proficiencies, number_of_districts)
  end

  def define_subject_growth_for_districts(grade, subject, weight)
    district_proficiencies = {}
    district_repo.districts.each do |district_name, district_object|
      year_range = get_year_range(district_object, grade, subject)
      next if year_range.empty?
      avg_growth = calculate_average_growth_for_subject(district_object, year_range, grade, subject)
      district_proficiencies[district_name] = truncate_float(avg_growth * weight)
    end
    district_proficiencies
  end

  def get_year_range(district_object, grade, subject)
    district_object.statewide_test.attributes[grade].keys.reject do |year|
      district_object.statewide_test.attributes[grade][year][subject].to_f == 0.0
    end
  end

  def calculate_average_growth_for_subject(district_object, year_range, grade, subject)
    latest = year_range.max
    earliest = year_range.min
    latest_percentage = district_object.statewide_test.attributes[grade][latest][subject]
    earliest_percentage = district_object.statewide_test.attributes[grade][earliest][subject]
    avg_growth = (latest_percentage - earliest_percentage) / (latest - earliest)
  end

  def sort_districts_by_proficiency(district_proficiencies)
    district_proficiencies.sort_by do |district, proficiency|
      proficiency
    end.reverse
  end

  def get_top_districts(sorted_proficiencies, number_of_districts)
    if sorted_proficiencies[0][1] == sorted_proficiencies[1][1]
      sorted_proficiencies[1]
    elsif
      number_of_districts == 1
      sorted_proficiencies.first
    else
      sorted_proficiencies[0..(number_of_districts - 1)]
    end
  end
#

# # if district_object.statewide_test.attributes[grade][latest][subject].to_f == 0.0
# #   latest_percentage = 0.0
# # else
#   latest_percentage = district_object.statewide_test.attributes[grade][latest][subject]
# # end


# def get_district_growth_for_one_subject(input)
#   last = get_latest_proficiency_data(grade, subject)
#   first = get_earliest_proficiency_data(grade, subject)
#   district_growth = calculate_proficiency_percentages(first, last) #puts proficiency in hash
#   #find min and max year for each district in particular subject
#   #calculate proficiency of (max year proficiency - min year proficiency) / max year - min year
#   #create hash of district pointing to proficiency percentage
# end
#
# def find_top_district_for_one_subject(district_growth, number = 1)
#   #return 'number' of max districts in array
# end
#
# def get_top_district_growth_for_all_subjects(input)
#   math = get_district_growth_for_one_subject()
#   reading = get_district_growth_for_one_subject()
#   writing = get_district_growth_for_one_subject()
#   get_district_growth_for_all_subjects
#     math_and_writing = math.merge(writing) |key, oldval, newval| ((oldval + newval) / 2 )
#     math_and_writing.merge(reading) |key, oldval, newval| ((oldval + newval) / 2 )
# end
#
# def top_district_growth_for_all_subjects_weighted
#   math = get_district_growth_for_one_subject(:math)
#   reading = get_district_growth_for_one_subject(:reading)
#   writing = get_district_growth_for_one_subject(:writing)
#   get_district_growth_for_all_subjects
# end
#
# def find_top_district_for_all_subjects(math, reading, writing)
#   math_and_writing = math.merge(writing) |key, oldval, newval| ((oldval + newval) / 2 )
#   math_and_writing.merge(reading) |key, oldval, newval| ((oldval + newval) / 2 )
# end





    #elsif input.keys includes grade && weighting && top
    #return top district with weighting
  #elsif input.keys includes grade && top
    #return top districts and growth for each subject
  #elsif input.keys includes grade && weighting
    #return top district weighted for all suljects
  #elsif input.keys includes grade && subjects
    #if grade is not valid return UnknownDataError
    #else return top state data



# grade, misc = {top: 1}, course = {course: [:math, :reading, :writing]}
  # if grade.keys.first != :grade
  #   raise InsufficientInformationError
  # elsif
  #else
    #if grade is not a known grade return UnknownDataError
    #elsif misc[key] is :subject
      #return top district for year over year growth in grade on subject
    #elsif misc[key] is :top
      # return top districts for year over year growth in topnumber in grade on subject
    #elsif misc[key] is :weighting
      #return top district for year over year growth in all subjects with weighting applied
    #elsif no other arguments besides grade
      #return top district for year over year growth in grade in all subjects

#
# def sample(district)
#   if district.keys[0] == :for
#     name = district[:for].upcase
#     if name == "STATEWIDE"
#       #Loop through every district in district repo
#       #Check if variance is true or false
#       # if the number of true is > 70%, return true
#       districts = district_repo.districts.reject { |district| district == "COLORADO"}
#       correlations = districts.reduce([]) do |data, name|
#         variance = kindergarten_participation_against_high_school_graduation(name.first)
#         data << true if variance >= 0.6 && variance <= 1.5
#         data << false if variance < 0.6 || variance > 1.5
#         data
#       end
#       total = correlations.count
#       # positive_correlations = correlations.reduce(0) do |sum, correlation|
#       #   sum += 1 if correlation == true
#       #   sum
#       # end
#       percentage = positive_correlations / total
#       # if percentage >= 0.7
#       #   true
#       # else
#       #   false
#       # end
#     else
#       #Check a particular district
#       variance = kindergarten_participation_against_high_school_graduation(name)
#       if variance > 0.6 && variance < 1.5
#         true
#       else
#         false
#       end
#     end
#   elsif district.keys[0] == :across
#     correlations = district[:across].reduce([]) do |data, name|
#       variance = kindergarten_participation_against_high_school_graduation(name)
#       data << true if variance >= 0.6 && variance <= 1.5
#       data << false if variance < 0.6 || variance > 1.5
#       data
#     end
#     total = correlations.count
#     # positive_correlations = correlations.reduce(0) do |sum, correlation|
#     #   sum += 1 if correlation == true
#     #   sum
#   end
#   percentage = positive_correlations / total
#   # if percentage >= 0.7
#   #   true
#   # else
#   #   false
#   # end
# end





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
