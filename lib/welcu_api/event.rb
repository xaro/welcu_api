module WelcuApi
  class Event
    attr_reader :id
    attr_reader :name
    attr_reader :starts_at
    attr_reader :ends_at
    attr_reader :locale
    attr_reader :timezone
    attr_reader :state
    attr_reader :url
    attr_reader :public
    attr_reader :location
    attr_reader :company
    attr_reader :tickets

    def initialize
      response = WelcuApi.request(:get, WelcuApi::Event.event_url, @api_key, {})
      json_event = MultiJson.load(response)

      @id = json_event["id"].to_i
      @name = json_event["name"]

      @starts_at = Time.new json_event["starts_at"]
      @ends_at = Time.new json_event["ends_at"]
      @locale = json_event["locale"].to_sym
      @timezone = json_event["timezone"]
      @state = json_event["state"].to_sym
      @url = json_event["url"]
      @public = json_event["public"] == "true"
      @company = WelcuApi::Company.new(json_event["company"]["id"], json_event["company"]["name"])
      @location = json_event["location"]

      @tickets = []
      json_event["tickets"].each do |ticket|
        @tickets << WelcuApi::Ticket.new(ticket)
      end
    end

    private
    def self.event_url
      '/event'
    end
  end
end