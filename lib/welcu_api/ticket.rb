module WelcuApi
  class Ticket
    attr_reader :id
    attr_reader :name
    attr_reader :starts_at
    attr_reader :ends_at
    attr_reader :location

    def initialize(ticket_json)
      @id = ticket_json["id"]
      @name = ticket_json["name"]
      @starts_at = Time.new ticket_json["starts_at"]
      @ends_at = Time.new ticket_json["ends_at"]
      @location = ticket_json["location"]
    end
  end
end