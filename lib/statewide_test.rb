require_relative 'errors'

class StatewideTest

attr_reader :attributes, :grades, :races, :subjects

  def initialize(attributes)
    @attributes = attributes
    @grades     = [3, 8]
    @subjects   = [:math, :reading, :writing]
    @races      = [:asian, :black, :pacific_islander, :hispanic,
                  :native_american, :two_or_more, :white]
  end

  def name
    attributes[:name].upcase
  end

  def proficient_by_grade(grade)
    raise UnknownDataError unless grades.include?(grade)
    attributes[grade]
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownRaceError unless races.include?(race)
    attributes[race]
  end

  def proficient_for_subject_by_grade_in_year(subj, grd, year)
    raise UnknownDataError unless subjects.include?(subj)&&grades.include?(grd)
    attributes[grd][year][subj]
  end

  def proficient_for_subject_by_race_in_year(subj, race, year)
    raise UnknownDataError unless subjects.include?(subj)&&races.include?(race)
    attributes[race][year][subj]
  end

end
