require_relative 'helper_methods'
require_relative 'errors'

class HeadcountAnalyst
  include HelperMethods
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district, comparison)
    avg1 = get_attribute_avg(district, :kindergarten_participation)
    avg2 = get_attribute_avg(comparison[:against], :kindergarten_participation)
    truncate_float(avg1 / avg2)
  end

  def kindergarten_participation_rate_variation_trend(district, comparison)
    data1 = get_district_data(district, :kindergarten_participation)
    data2 = get_district_data(comparison[:against], :kindergarten_participation)
    averages = data1.merge(data2){ |key, a, b| truncate_float(b / a) }
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

  def get_attribute_avg(district, school_type)
    d = get_district_data(district, school_type)
    calculate_average(d.values)
  end

  def calculate_variance(district_avg, state_avg)
    district_avg / state_avg
  end

  def variance_against_state(district, school_type)
    k_district = get_attribute_avg(district, school_type)
    k_state = get_attribute_avg("Colorado", school_type)
    k_variance = calculate_variance(k_district, k_state)
  end

  def kindergarten_participation_against_high_school_graduation(district)
    k_variance = variance_against_state(district, :kindergarten_participation)
    hs_variance = variance_against_state(district, :high_school_graduation)
    total_variance = calculate_variance(k_variance, hs_variance)
    truncate_float(total_variance)
  end

  def correlation_trend_exists?(percentage)
    percentage >= 0.7
  end

  def is_correlated?(variance)
    variance >= 0.6 && variance <= 1.5
  end

  def count_positive_correlations(correlations)
    correlations.count { |i| i == true }
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

  def kindergarten_participation_correlates_with_high_school_graduation(name)
    if name.keys[0] == :for
      name = name[:for].upcase
      if name == "STATEWIDE"
        district_names = omit_statewide_data(district_repo.districts)
        check_for_correlation_trend(district_names.keys)
      else
        check_for_single_correlation(name)
      end
    elsif name.keys[0] == :across
        check_for_correlation_trend(name[:across])
    end
  end

  def top_statewide_test_year_over_year_growth(input)
    #EXCLUDE COLORADO FROM DISTRICTS
    grade = input[:grade]
    subject = input[:subject]
    district_num = input[:top]
    district_num = 1 if district_num.nil?
    weight = input[:weighting]
    weight = {math: 1.0, reading: 1.0, writing: 1.0} if weight.nil?

    if grade.nil?
      raise InsufficientInformationError
    elsif ![3, 8].include?(grade)
      raise UnknownDataError
    elsif subject.nil?
        top_growth_for_all_subjects(grade, district_num, weight)
    else
        top_growth_for_subject(grade, subject, district_num, weight[subject])
    end
  end

  def top_growth_for_all_subjects(grade, district_num, weight)
    math = define_subject_growth(grade, :math, weight[:math])
    reading = define_subject_growth(grade, :reading, weight[:reading])
    writing = define_subject_growth(grade, :writing, weight[:writing])
    proficiencies = assemble_valid_averages(math, reading, writing, weight)
    get_top_districts(proficiencies, district_num)
  end

  def merge_proficiencies(m, r, w)
    mw = m.merge(w) { |key, a, b| [a] + [b] }
    mw.merge(r) { |key, a, b| ([a] + [b]).flatten(1) }
  end

  def select_valid_proficiencies(district_proficiencies)
    district_proficiencies.select do |name, percentage|
      percentage.is_a? Array || percentage.count == 3
    end
  end

  def assemble_valid_averages(m, r, w, weight)
    district_proficiencies = merge_proficiencies(m, r, w)
    proficiencies = select_valid_proficiencies(district_proficiencies)
    district_avg = calculate_average_proficiencies(proficiencies, weight)
    sorted_proficiencies = sort_districts_by_proficiency(district_avg)
  end

  def calculate_average_proficiencies(proficiencies, weight)
    if is_weighted?(weight)
      calculate_by_weight(proficiencies, weight, 1.0)
    else
      calculate_by_weight(proficiencies, weight, 3.0)
    end
  end

  def is_weighted?(weight)
    weight.values.reduce(:+) == 1.0
  end

  def calculate_by_weight(proficiencies, weight, number)
    proficiencies.each do |key, value|
      proficiencies[key] = value.reduce(:+) / number
    end
  end

  def top_growth_for_subject(grade, subject, district_num, weight)
    district_proficiencies = define_subject_growth(grade, subject, weight)
    sorted_proficiencies = sort_districts_by_proficiency(district_proficiencies)
    get_top_districts(sorted_proficiencies, district_num)
  end

  def define_subject_growth(grade, subject, weight)
    proficiencies = {}
    district_repo.districts.each do |district_name, district|
      year_range = get_year_range(district, grade, subject)
      next if year_range.empty?
      avg_growth = get_growth_for_subject(district, year_range, grade, subject)
      proficiencies[district_name] = truncate_float(avg_growth * weight)
    end
    proficiencies
  end

  def get_year_range(district, grade, subject)
    district.statewide_test.attributes[grade].keys.reject do |year|
      district.statewide_test.attributes[grade][year][subject].to_f == 0.0
    end
  end

  def get_growth_for_subject(district, year_range, grade, subject)
    latest = year_range.max
    earliest = year_range.min
    latest_data = district.statewide_test.attributes[grade][latest][subject]
    earliest_data = district.statewide_test.attributes[grade][earliest][subject]
    avg_growth = (latest_data - earliest_data) / (latest - earliest)
  end

  def sort_districts_by_proficiency(district_proficiencies)
    district_proficiencies.sort_by do |district, proficiency|
      proficiency
    end.reverse
  end

  def get_top_districts(sorted_proficiencies, district_num)
    if sorted_proficiencies[0][1] == sorted_proficiencies[1][1]
      sorted_proficiencies[1]
    elsif
      district_num == 1
      sorted_proficiencies.first
    else
      sorted_proficiencies[0..(district_num - 1)]
    end
  end

end
