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

  describe ".create_run" do
    it "should create new run in webspec web app" do
      Webspec.stub(:api_key => "abc123")
      Webspec.should_receive(:post).
        with("https://webspec.shellyapp.com/projects/abc123/runs.json",
          {:body => {:run => {:a => :b}}}).and_return({"_id" => "123"})
      Webspec::Run.should_receive(:new).with({"_id" => "123"})
      Webspec.create_run({:a => :b})
    end
  end
end
