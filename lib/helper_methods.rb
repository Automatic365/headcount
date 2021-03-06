module HelperMethods

  def truncate_float(float)
    float = 0 if float.nan?
    (float * 1000).floor / 1000.to_f
  end

  def calculate_average(data)
    data.reduce(0, :+) / data.count
  end

  def has_year?(category, year)
    attributes[category][year] != nil
  end

end
