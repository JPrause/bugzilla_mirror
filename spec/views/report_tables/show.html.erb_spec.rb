require 'spec_helper'

describe "report_tables/show" do
  before(:each) do
    @report_table = assign(:report_table, stub_model(ReportTable,
      :name        => "Name",
      :description => "MyText",
      :query_name  => "MyText",
      :vertical    => "vertical",
      :horizontal  => "horizontal"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/vertical/)
    rendered.should match(/horizontal/)
  end
end
