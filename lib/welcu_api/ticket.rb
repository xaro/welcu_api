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

    def self.check(code, checked_at=nil)
      params = checked_at.nil? ? {} : uri_encode({ at: checked_at })

      response = WelcuApi.request(:post, WelcuApi::Ticket.check_ticket_url(code), @api_key, params)
    end

    private
    def self.check_ticket_url(code)
      "/event/attendees/code/#{code}/check"
    end
  end
end