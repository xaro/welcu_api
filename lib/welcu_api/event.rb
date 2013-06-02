module WelcuApi
  class Event
    def self.get
      response = WelcuApi.request(:get, self.event_url, @api_key, {})
    end

    def method_missing(name, *args, &block)
      event.has_key?(name.to_s) ? event[name.to_s] : super
    end

    private
    def self.event_url
      '/event'
    end
  end
end