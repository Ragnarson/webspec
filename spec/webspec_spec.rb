require 'spec_helper'

describe Webspec do
  describe "configure_rspec" do
    it "should add Webspec::Formatter to RSpec configuration" do
      configuration = mock
      RSpec.should_receive(:configuration).and_return(configuration)
      configuration.should_receive(:add_formatter).with(Webspec::Formatter)
      Webspec.configure_rspec
    end
  end

  describe "report" do
    it "should send output_hash to webspec web app" do
      Webspec.stub(:api_key => "abc123")
      Webspec.should_receive(:post).
        with("https://webspec.shellyapp.com/projects/abc123/runs.json",
          {:body => {:run => {:a => :b}}}).and_return(true)
      Webspec.report({:a => :b})
    end
  end
end
