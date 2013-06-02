module WelcuApi
  class Company
    attr_reader :id
    attr_reader :name

    def initialize(id, name)
      @id = id
      @name = name
    end
  end
end