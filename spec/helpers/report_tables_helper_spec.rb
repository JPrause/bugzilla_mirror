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

  test_query_name = "TestSoxQuery99"
  local_query = nil
  saved_bz_cmd = ApplicationHelper::BZ_CMD
  saved_bz_cookies_file = ApplicationHelper::BZ_COOKIES_FILE

  class LocalReportTable
    attr_accessor :query_id, :query_name

    def initialize(test_query_name)
      @query_id = 0
      @query_name = test_query_name
    end
  end

  # Run after each tests to reset any faked ApplicationHelper constants.
  before :each do
    @file = Tempfile.new('cfme_bz_spec')
    silence_warnings do
      # Fake the bugzilla cookies file and the bugzilla command.
      ApplicationHelper::BZ_COOKIES_FILE = @file.path
      ApplicationHelper::BZ_CMD = '/bin/echo'
    end
    local_query = BzQuery.create(
      description: "Test Query.",
      name: test_query_name,
      product: nil, 
      flag: nil,
      bug_status: nil,
      output_format: nil)
    local_query.run(local_query)
    local_query.run(local_query)
    local_query.run(local_query)
    local_query.run(local_query)
  end

  after :each do
    silence_warnings do
      ApplicationHelper::BZ_CMD = saved_bz_cmd
      ApplicationHelper::BZ_COOKIES_FILE = saved_bz_cookies_file
    end
    local_query.destroy
    @file.close
    @file.unlink
  end

  context "#get_latest_bz_query" do
    it "Handle query name not found." do
      expect{get_latest_bz_query("INVALID QUERY NAME")}.to raise_exception
    end

    it "Handle a valid bz query with valid output." do
      get_latest_bz_query(test_query_name).should_not == 0
    end
  end

  context "#get_bz_query_run_times" do
    it "Handle query name not found." do
      get_bz_query_run_times("INVALID QUERY NAME").should ==
        [["LATEST", "LATEST"]]
    end

    it "Handle a valid bz query with valid run times." do
      get_bz_query_run_times(test_query_name).count.should == 5
    end
  end

  context "#get_bz_query_run_time" do
    it "Handle query name not found." do
      get_bz_query_run_time(0).should == "LATEST"
    end

    it "Handle a valid bz query with a valid run time." do
      valid_query_id = BzQuery.find_by_name(test_query_name).bz_query_outputs.pluck(:id)[0]
      get_bz_query_run_time(valid_query_id).should be_within(10.minutes).of(Time.now)
    end
  end

  context "#get_query_output" do
    report_table = LocalReportTable.new("INVALID_NAME")

    it "Handle an invalid report_table query_id and query_name." do
      expect{get_query_output(report_table)}.to raise_exception
    end

    it "Handle a valid report_table query_id and query_name." do
      report_table.query_id = get_latest_bz_query(test_query_name)
      report_table.query_name = test_query_name
      get_query_output(report_table).should ==  "query\n"
    end
  end

  context "#get_query_element" do
    it "Handle an invalid element name." do
      get_query_element("INVALID_ELEMENT_NAME", 0).should == []
    end

    it "Handle a valid element name." do
      valid_query_id = BzQuery.find_by_name(test_query_name).bz_query_outputs.pluck(:id)[0]
      get_query_element("output", valid_query_id).should == "query\n"
    end
  end

end

