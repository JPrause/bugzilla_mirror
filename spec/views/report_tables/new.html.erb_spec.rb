require 'spec_helper'

describe "report_tables/new" do
  before(:each) do
    assign(:report_table, stub_model(ReportTable,
      :name => "MyString",
      :description => "MyText",
      :query_name => "MyText",
      :vertical => "MyString",
      :horizontal => "MyString"
    ).as_new_record)
  end

  it "renders new report_table form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", report_tables_path, "post" do
      assert_select "input#report_table_name[name=?]", "report_table[name]"
      assert_select "textarea#report_table_description[name=?]", "report_table[description]"
      assert_select "textarea#report_table_query_name[name=?]", "report_table[query_name]"
      assert_select "input#report_table_vertical[name=?]", "report_table[vertical]"
      assert_select "input#report_table_horizontal[name=?]", "report_table[horizontal]"
    end
  end
end
