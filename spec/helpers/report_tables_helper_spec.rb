require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'tempfile'

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

  class LocalReportTable
    attr_accessor :query_id, :query_name

    def initialize(test_query_name)
      @query_id = 0
      @query_name = test_query_name
    end
  end

  # Run before each tests to reset any faked BzCommand constants.
  # and create a test query.
  before :each do
    @saved_cmd = BzCommand::CMD
    @saved_cookies_file = BzCommand::COOKIES_FILE
    @test_query_name = "TestSoxQuery99"
    @file = Tempfile.open('cfme_bz_spec')

    silence_warnings do
      # Fake the bugzilla cookies file and the bugzilla command.
      BzCommand::COOKIES_FILE = @file.path
      BzCommand::CMD = '/bin/echo'
    end
    @local_query = BzQuery.create(
      :description   => "Test Query",
      :name          => @test_query_name,
      :product       => "cfme_test_product", 
      :flag          => nil,
      :bug_status    => nil,
      :output_format => nil)
    4.times { @local_query.run }
  end

  # Run after each tests to reset any faked BzCommand constants.
  after :each do
    silence_warnings do
      BzCommand::CMD = @saved_cmd
      BzCommand::COOKIES_FILE = @saved_cookies_file
    end
    @local_query.destroy
    @file.close unless @file.nil?
    @file.unlink unless @file.nil?
  end

  context "#get_bz_query_run_times" do
    it "when the query name is not found" do
      get_bz_query_run_times("INVALID QUERY NAME").should ==
        [["LATEST", "LATEST"]]
    end

    it "with a valid query that contains valid run times" do
      get_bz_query_run_times(@test_query_name).count.should == 5
    end
  end

  context "#get_bz_query_run_time" do
    it "when the query name is not found" do
      get_bz_query_run_time(0).should == "LATEST"
    end

    it "with a valid query that contains a valid run time" do
      valid_query_id = BzQuery.find_by_name(@test_query_name).bz_query_outputs.pluck(:id)[0]
      get_bz_query_run_time(valid_query_id).should be_within(10.minutes).of(Time.now)
    end
  end

end

