class Enrollment

attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
  end

## check to see that district exists in the repository
# use detect method

  def kindergarten_participation_by_year(year)
    attributes[:kindergarten_participation].reduce({}) do |result, pair|
      result.merge{pair.first => truncate_float(pair.last)}
      result
    end
  end

  def truncate_float(float)
    (float * 1000).floor / 1000.to_f
  end

end
