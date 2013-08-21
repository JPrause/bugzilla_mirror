require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'spec_helper'
require 'rspec/rails'

describe BzQueryOutput do

  context "#BzQueryOutput.new" do
    it "with empty attributes" do
      q_out = BzQueryOutput.new
      q_out.should be_valid
    end

    it "when specifying output" do
      q_out = BzQueryOutput.new(:output => "hi")
      q_out.output.should == "hi"
    end
  end

end


