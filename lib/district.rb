class District

attr_reader :district

  def initialize(hash)
    @district = hash
  end

  def name
    district[:name].upcase
  end

end
