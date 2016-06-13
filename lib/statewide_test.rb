require_relative 'errors'

class StatewideTest

attr_reader :attributes, :grades, :races, :subjects

  def initialize(attributes)
    @attributes = attributes
    @grades = [3, 8]
    @races = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
    @subjects = [:math, :reading, :writing]
  end

  def name
    attributes[:name].upcase
  end

  # def raise_unknown_data_error
  #   raise UnknownDataError
  # end

  def proficient_by_grade(grade)
    if grades.include?(grade)
      attributes[grade]
    else
      raise UnknownDataError
    end
  end

  def proficient_by_race_or_ethnicity(race)
    if races.include?(race)
      attributes[race]
    else
      raise UnknownRaceError
    end
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    if subjects.include?(subject) && grades.include?(grade)
      attributes[grade][year][subject]
    else
      raise UnknownDataError
    end
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    if subjects.include?(subject) && races.include?(race)
      attributes[race][year][subject]
    else
      raise UnknownDataError
    end
  end

end
