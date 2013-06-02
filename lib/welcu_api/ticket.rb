module WelcuApi
  class Ticket
    attr_reader :id
    attr_reader :name
    attr_reader :starts_at
    attr_reader :ends_at
    attr_reader :location
    attr_reader :code

    def initialize(ticket_json)
      @id = (ticket_json["id"] || ticket_json["ticket_id"]).to_i
      @name = ticket_json["name"]
      @code = ticket_json["code"]
      @starts_at = Time.new(ticket_json["starts_at"]) unless ticket_json["starts_at"].nil?
      @ends_at = Time.new(ticket_json["ends_at"]) unless ticket_json["ends_at"].nil?
      @location = ticket_json["location"]
    end
  end
end