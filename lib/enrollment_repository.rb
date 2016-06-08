class EnrollmentRepository

  def initialize(enrollments = [])
    @enrollments = enrollments
    #respositories.each do |repo|
    # names = repo.collection.amp(&:name)
    # repo.collection.amp do |item|
    #   item.name
    # end.uniq
    # @districts = names.map do |name|
    #   District.new(name: name)
  end

  def load_data(file_tree)

  end

  def find_by_name(name)
    @enrollments.find do |enrollment|
      enrollment[:name] == name
    end
  end

end
