require 'spec_helper'

describe BzQueryOutput do

  it "is valid with empty attributes" do
    q_out = BzQueryOutput.new
    q_out.should be_valid
  end

  it "is valid to set output" do
    q_out = BzQueryOutput.new(output: "hi")
    q_out.output.should == "hi"
  end

end


