class District
attr_reader :attributes, :dr
# attr_accessor :enrollment, :statewide_test, :economic_profile

  def initialize(attributes, dr = nil)
    @attributes = attributes
    @dr = dr
  end

  def name
    attributes[:name].upcase
  end

  def enrollment
    dr.find_enrollment(attributes[:name])
  end

  def statewide_test
    dr.find_statewide_test(attributes[:name])
  end

  def economic_profile
    dr.find_economic_profile(attributes[:name])
  end

end
