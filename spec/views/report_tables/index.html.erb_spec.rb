require 'spec_helper'

describe "report_tables/index" do
  before(:each) do
    assign(:report_tables, [
      stub_model(ReportTable,
        :name => "Name",
        :description => "MyText",
        :query_name => "MyText",
        :Vertical => "Vertical",
        :Horizontal => "Horizontal"
      ),
      stub_model(ReportTable,
        :name => "Name",
        :description => "MyText",
        :query_name => "MyText",
        :Vertical => "Vertical",
        :Horizontal => "Horizontal"
      )
    ])
  end

  it "renders a list of report_tables" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 4
    assert_select "tr>td", :text => "MyText".to_s, :count => 4
    assert_select "tr>td", :text => "Vertical".to_s, :count => 2
    assert_select "tr>td", :text => "Horizontal".to_s, :count => 2
  end
end
