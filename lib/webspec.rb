require "webspec/version"
require "webspec/formatter"
require "httparty"
require "json"

module Webspec
  include HTTParty

  class << self
    attr_accessor :api_key

    def base_url
      ENV['WEBSPEC_URL'] || "https://webspec.shellyapp.com"
    end

    def configure_rspec
      RSpec.configuration.add_formatter(Webspec::Formatter)
    end

    def report(output_hash)
      FakeWeb.allow_net_connect = true if defined?(FakeWeb)
      url = "#{base_url}/projects/#{api_key}/runs.json"
      post(url, :body => {:run => output_hash})
    end
  end
end
