class Enrollment

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

  def truncate_float(float)
    (float * 1000).floor / 1000.to_f
  end

  def kindergarten_participation_in_year(year)
      if attributes[:kindergarten_participation][year] != nil
        truncate_float(attributes[:kindergarten_participation][year])
      end
  end

end
