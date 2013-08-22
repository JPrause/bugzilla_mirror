require File.expand_path(File.join(File.dirname(__FILE__), '../..', 'spec_helper'))
require 'tempfile'

include QueryMixin

describe QueryMixin do

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
    @saved_bz_cmd = BzCommand::CMD
    @saved_bz_cookies_file = BzCommand::COOKIES_FILE
    @test_query_name = "TestSoxQuery99"
    @file = Tempfile.new('cfme_bz_spec')

    silence_warnings do
      # Fake the bugzilla cookies file and the bugzilla command.
      BzCommand::COOKIES_FILE = @file.path
      BzCommand::CMD = '/bin/echo'
    end
    @local_query = BzQuery.create(
      :description => "Test Query",
      :name => @test_query_name,
      :product => "My Test Product", 
      :flag => nil,
      :bug_status => nil,
      :output_format => nil)
    1.times { @local_query.run(@local_query) }
  end

  # Run after each tests to reset any faked BzCommand constants.
  after :each do
    silence_warnings do
      BzCommand::CMD = @saved_bz_cmd
      BzCommand::COOKIES_FILE = @saved_bz_cookies_file
    end
    @local_query.destroy
    @file.close
    @file.unlink
  end

  context "#get_latest_bz_query" do
    it "when the query name is not found" do
      expect{get_latest_bz_query("INVALID QUERY NAME")}.to raise_exception
    end

    it "with a valid query that contains valid output" do
      get_latest_bz_query(@test_query_name).should_not == 0
    end
  end

  context "#get_query_output" do
    report_table = LocalReportTable.new("INVALID_NAME")

    it "with invalid report_table query_id and query_name params" do
      expect{get_query_output(report_table)}.to raise_exception
    end

    it "with valid report_table query_id and query_name params" do
      report_table.query_id = get_latest_bz_query(@test_query_name)
      report_table.query_name = @test_query_name
      get_query_output(report_table).should ==
        "query --product=My Test Product\n"
    end
  end

  context "#get_query_element" do
    it "with an invalid element name" do
      expect{get_query_element("INVALID_ELEMENT_NAME", 0)}.to raise_exception
    end

    it "with a valid element name" do
      valid_query_id =
        BzQuery.find_by_name(@test_query_name).bz_query_outputs.pluck(:id)[0]
      get_query_element("output", valid_query_id).should ==
        "query --product=My Test Product\n"
    end
  end

end

