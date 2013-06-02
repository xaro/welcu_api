require "rest_client"
require "multi_json"

require "welcu_api/event"
require "welcu_api/company"
require "welcu_api/ticket"

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
    Util.flatten_params(params).
      map { |k,v| "#{k}=#{Util.url_encode(v)}" }.join('&')
  end

  def self.execute_request(opts)
    puts opts.inspect
    RestClient::Request.execute(opts)
  end
end