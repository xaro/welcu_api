require "rest_client"
require "multi_json"

require "welcu_api/event"
require "welcu_api/company"
require "welcu_api/ticket"
require "welcu_api/attendee"

module WelcuApi
  @api_base = "http://api.welcu.com/v1"

  class << self
    attr_accessor :api_base, :api_key
  end

  def self.api_url(url='')
    @api_base + url + '.json'
  end

  def self.request(method, url, api_key, params={}, headers={})
    api_key ||= @api_key

    url = api_url(url)

    case method.to_s.downcase.to_sym
    when :get, :head, :delete
      # Make params into GET parameters
      url += "#{URI.parse(url).query ? '&' : '?'}#{uri_encode(params)}" if params && params.any?
      payload = nil
    else
      payload = uri_encode(params)
    end

    request_opts = { :headers => request_headers(api_key).update(headers),
                      :method => method, :open_timeout => 30,
                      :payload => payload, :url => url, :timeout => 80 }

    response = execute_request(request_opts)
  end


  private
  def self.request_headers(api_key)
    headers = {
      :user_agent => "Welcu/v1 RubyBindings",
      :authorization => "event #{api_key}",
      :content_type => 'application/x-www-form-urlencoded'
    }
  end

  def self.uri_encode(params)
    flatten_params(params).
      map { |k,v| "#{k}=#{url_encode(v)}" }.join('&')
  end

  def self.execute_request(opts)
    RestClient::Request.execute(opts)
  end

  def self.url_encode(key)
      URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  def self.flatten_params(params, parent_key=nil)
    result = []
    params.each do |key, value|
      calculated_key = parent_key ? "#{parent_key}[#{url_encode(key)}]" : url_encode(key)
      if value.is_a?(Hash)
        result += flatten_params(value, calculated_key)
      elsif value.is_a?(Array)
        result += flatten_params_array(value, calculated_key)
      else
        result << [calculated_key, value]
      end
    end
    result
  end
end