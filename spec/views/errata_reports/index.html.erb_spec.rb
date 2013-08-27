require 'spec_helper'

describe "errata_reports/index" do
  before(:each) do
    assign(:errata_reports, [
      stub_model(ErrataReport,
        :name => "Name",
        :description => "MyText",
        :query_id => "Query",
        :query_name => "Query Name",
        :query_occurrence => "Query occurrence",
        :version => "Version",
        :email_addr_pm_ack => "Email Addr Pm Ack",
        :email_addr_devel_ack => "Email Addr Devel Ack",
        :email_addr_qa_ack => "Email Addr Qa Ack",
        :send_email_pm_ack => false,
        :send_email_devel_ack => false,
        :send_email_qa_ack => false
      ),
      stub_model(ErrataReport,
        :name => "Name",
        :description => "MyText",
        :query_id => "Query Id",
        :query_name => "Query Name",
        :query_occurrence => "Query occurrence",
        :version => "Version",
        :email_addr_pm_ack => "Email Addr Pm Ack",
        :email_addr_devel_ack => "Email Addr Devel Ack",
        :email_addr_qa_ack => "Email Addr Qa Ack",
        :send_email_pm_ack => false,
        :send_email_devel_ack => false,
        :send_email_qa_ack => false
      )
    ])
  end

  it "renders a list of errata_reports" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Query Id".to_s, :count => 2
    assert_select "tr>td", :text => "Query Name".to_s, :count => 2
    assert_select "tr>td", :text => "Query occurrence".to_s, :count => 2
    assert_select "tr>td", :text => "Version".to_s, :count => 2
    assert_select "tr>td", :text => "Email Addr Pm Ack".to_s, :count => 2
    assert_select "tr>td", :text => "Email Addr Devel Ack".to_s, :count => 2
    assert_select "tr>td", :text => "Email Addr Qa Ack".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
