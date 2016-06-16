require_relative 'helper_methods'

class Enrollment
  include HelperMethods
  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def kindergarten_participation_by_year
    attributes[:kindergarten_participation].reduce({}) do |result, pair|
      result.merge!(pair.first => truncate_float(pair.last))
      result
    end
  end

  def kindergarten_participation_in_year(year)
      if has_year?(:kindergarten_participation, year)
        truncate_float(attributes[:kindergarten_participation][year])
      end
  end

  def graduation_rate_by_year
    attributes[:high_school_graduation].reduce({}) do |result, pair|
      result.merge!(pair.first => truncate_float(pair.last))
      result
    end
  end

  def graduation_rate_in_year(year)
    if has_year?(:high_school_graduation, year)
      truncate_float(attributes[:high_school_graduation][year])
    end
  end

  def name
    attributes[:name].upcase
  end

end
