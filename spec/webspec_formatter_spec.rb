require 'spec_helper'

describe Webspec::Formatter do
  let(:formatter) { Webspec::Formatter.new(nil) }

  it "should initialize empty output hash" do
    formatter.output_hash.should == {:elements => []}
  end

  it "should add message to output_hash" do
    formatter.message("test message")
    formatter.output_hash[:messages].should == ["test message"]
  end

  it "should add summary to output hash" do
    formatter.dump_summary(1.5, 10, 1, 2)
    formatter.output_hash[:summary].should eql({
      :duration => 1.5,
      :example_count => 10,
      :failure_count => 1,
      :pending_count => 2
    })
    formatter.output_hash[:summary_line].should
      eql("10 examples, 1 failure, 2 pending")
  end

  it "should add examples to output hash"

  describe "on close" do
    it "should report the run to Webspec" do
      Webspec.should_receive(:report).with(formatter.output_hash)
      formatter.close
    end
  end
end
