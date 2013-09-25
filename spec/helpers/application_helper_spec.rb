require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the StatisticsReportsHelper. For example:
#
# describe StatisticsReportsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe ApplicationHelper do

  context "#get_bugzilla_uri" do

    it "when a valid response is returned" do
      res = get_bugzilla_uri
      res = get_bugzilla_uri.should include("/show_bug.cgi?id=")
    end

    it "when the default response is returned" do
      RubyBugzilla::CREDS_FILE = "/file/not/found"
      res = get_bugzilla_uri
      res = get_bugzilla_uri.should == ("https://bugzilla.redhat.com/show_bug.cgi?id=")
    end

  end

end
