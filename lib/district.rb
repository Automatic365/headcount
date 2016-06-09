class District
attr_reader :attributes
attr_accessor :enrollment

  def initialize(attributes)
    @attributes = attributes
  end

  def name
    attributes[:name].upcase
  end

end
