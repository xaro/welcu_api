module WelcuApi
  class Attendee
    attr_reader :id
    attr_reader :first_name
    attr_reader :last_name
    attr_reader :title
    attr_reader :email
    attr_reader :phone
    attr_reader :facebook_uid
    attr_reader :reference_key
    attr_reader :tickets

    def initialize(attendee_json)
      @id = attendee_json["id"].to_i
      @first_name = attendee_json["first_name"]
      @last_name = attendee_json["last_name"]
      @organization = attendee_json["organization"]
      @title = attendee_json["title"]
      @email = attendee_json["email"]
      @phone = attendee_json["phone"]
      @facebook_uid = attendee_json["facebook_uid"]
      @reference_key = attendee_json["reference_key"]

      @tickets = []
      attendee_json["tickets"].each do |ticket|
        puts ticket.inspect
        @tickets << WelcuApi::Ticket.new(ticket)
      end
    end

    def self.all(options={})
      case options[:state]
      when :checked
        url = WelcuApi::Attendee.checked_url
      when :unchecked
        url = WelcuApi::Attendee.unchecked_url
      else
        url = WelcuApi::Attendee.attendee_url
      end

      params = {}
      params.update(ticket_id = options["ticket_id"]) unless options["ticket_id"].nil?

      response = WelcuApi.request(:get, url, @api_key, {})
      attendees_json = MultiJson.load(response)

      attendees = []
      attendees_json.each do |attendee_json|
        attendees << WelcuApi::Attendee.new(attendee_json)
      end

      attendees
    end

    def self.find_by_code(code)
      response = WelcuApi.request(:get, WelcuApi::Attendee.attendee_by_code_url(code), @api_key, {})
      attendee_json = MultiJson.load(response)

      Attendee.new(attendee_json)
    end

    def full_name
      "#{first_name} #{last_name}"
    end

    private
    def self.attendee_url
      '/event/attendees'
    end

    def self.checked_url
      '/event/attendees/checked'
    end

    def self.unchecked_url
      '/event/attendees/unchecked'
    end

    def self.attendee_by_code_url(code)
      "/event/attendees/code/#{code}"
    end
  end
end