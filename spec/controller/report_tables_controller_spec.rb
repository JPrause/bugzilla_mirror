require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe ReportTable do

  context "#run" do
    it "running an invalid report should return nothing" do
      report_table = ReportTable.create(
        name: 'Report1',
        description: 'vertical=Version horizontal=Status',
        query_name: 'none',
        query_id: nil, 
        vertical: 'none',
        horizontal: 'none')

      expect{report_table.run(report_table)}.to raise_exception
    end
  end
end
