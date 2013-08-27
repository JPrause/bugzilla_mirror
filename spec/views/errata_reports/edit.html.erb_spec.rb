require 'spec_helper'

describe "errata_reports/edit" do
  before(:each) do
    @errata_report = assign(:errata_report, stub_model(ErrataReport,
      :name => "MyString",
      :description => "MyText",
      :query_id => "MyString",
      :query_name => "MyString",
      :query_occurrence => "MyString",
      :version => "MyString",
      :email_addr_pm_ack => "MyString",
      :email_addr_devel_ack => "MyString",
      :email_addr_qa_ack => "MyString",
      :send_email_pm_ack => false,
      :send_email_devel_ack => false,
      :send_email_qa_ack => false
    ))
  end

  it "renders the edit errata_report form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", errata_report_path(@errata_report), "post" do
      assert_select "input#errata_report_name[name=?]", "errata_report[name]"
      assert_select "textarea#errata_report_description[name=?]", "errata_report[description]"
      assert_select "input#errata_report_query_id[name=?]", "errata_report[query_id]"
      assert_select "input#errata_report_query_name[name=?]", "errata_report[query_name]"
      assert_select "input#errata_report_query_occurrence[name=?]", "errata_report[query_occurrence]"
      assert_select "input#errata_report_version[name=?]", "errata_report[version]"
      assert_select "input#errata_report_email_addr_pm_ack[name=?]", "errata_report[email_addr_pm_ack]"
      assert_select "input#errata_report_email_addr_devel_ack[name=?]", "errata_report[email_addr_devel_ack]"
      assert_select "input#errata_report_email_addr_qa_ack[name=?]", "errata_report[email_addr_qa_ack]"
      assert_select "input#errata_report_send_email_pm_ack[name=?]", "errata_report[send_email_pm_ack]"
      assert_select "input#errata_report_send_email_devel_ack[name=?]", "errata_report[send_email_devel_ack]"
      assert_select "input#errata_report_send_email_qa_ack[name=?]", "errata_report[send_email_qa_ack]"
    end
  end
end
