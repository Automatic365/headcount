class District

attr_reader :district

  def initialize(district)
    @district = district
  end

  def name
    district[:name].upcase
  end

end
