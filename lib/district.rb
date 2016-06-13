class District
attr_reader :attributes
attr_accessor :enrollment, :statewide_test, :economic_profile

  def initialize(attributes)
    @attributes = attributes
  end

  def name
    attributes[:name].upcase
  end

end
