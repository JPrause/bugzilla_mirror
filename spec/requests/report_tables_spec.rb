require 'spec_helper'

describe "ReportTables" do
  describe "GET /report_tables" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get report_tables_path
      response.status.should be(200)
    end
  end
end
