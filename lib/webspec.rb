require "webspec/version"
require "webspec/formatter"
require "webspec/run"
require "webspec/example_group"
require "webspec/example"
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

    def create_run(run_params = {})
      allow_net_connect do
        url = "#{base_url}/projects/#{api_key}/runs.json"
        response = post(url, :body => {:run => run_params})
        Webspec::Run.new(response.to_hash)
      end
    end

    def update_run(run_id, run_params = {})
      allow_net_connect do
        url = "#{base_url}/projects/#{api_key}/runs/#{run_id}.json"
        response = put(url, :body => {:run => run_params})
        Webspec::Run.new(response.to_hash)
      end
    end

    def create_example_group(example_group_params, run, parent = nil)
      allow_net_connect do
        url = "#{base_url}/projects/#{api_key}/runs/#{run.id}/example_groups.json"
        response = post(url, :body => {
          :example_group => example_group_params,
          :parent_id => (parent.id if parent)
        })
        Webspec::ExampleGroup.new(response.to_hash.merge(:run => run))
      end
    end

    def create_example(example_params, run, parent = nil)
      allow_net_connect do
        url = "#{base_url}/projects/#{api_key}/runs/#{run.id}/examples.json"
        response = post(url, :body => {
          :example => example_params,
          :parent_id => (parent.id if parent)
        })
        Webspec::Example.new(response.to_hash.merge(:run => run))
      end
    end

    def allow_net_connect
      if defined?(FakeWeb)
        allow_net_connect = FakeWeb.allow_net_connect
        FakeWeb.allow_net_connect = true
        yield
        FakeWeb.allow_net_connect = allow_net_connect
      else
        yield
      end
    end
  end
end
