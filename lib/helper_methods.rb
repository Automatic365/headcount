module HelperMethods

  def truncate_float(float)
    (float * 1000).floor / 1000.to_f
  end

end
