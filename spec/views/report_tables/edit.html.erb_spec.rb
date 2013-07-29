require 'spec_helper'

describe "report_tables/edit" do
  before(:each) do
    @report_table = assign(:report_table, stub_model(ReportTable,
      :name => "MyString",
      :description => "MyText",
      :query_name => "MyText",
      :Vertical => "MyString",
      :Horizontal => "MyString"
    ))
  end

  it "renders the edit report_table form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", report_table_path(@report_table), "post" do
      assert_select "input#report_table_name[name=?]", "report_table[name]"
      assert_select "textarea#report_table_description[name=?]", "report_table[description]"
      assert_select "textarea#report_table_query_name[name=?]", "report_table[query_name]"
      assert_select "input#report_table_Vertical[name=?]", "report_table[Vertical]"
      assert_select "input#report_table_Horizontal[name=?]", "report_table[Horizontal]"
    end
  end
end
