require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ReportTablesHelper. For example:
#
# describe ReportTablesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ReportTablesHelper do
  context "#get_bz_query_run_times" do
    it "Handle query name not found." do
      get_bz_query_run_times("INVALID QUERY NAME").should ==
        [["LATEST", "LATEST"]]
    end
  end
end

