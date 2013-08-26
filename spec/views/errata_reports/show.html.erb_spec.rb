require 'spec_helper'

describe "errata_reports/show" do
  before(:each) do
    @errata_report = assign(:errata_report, stub_model(ErrataReport,
      :name => "Name",
      :description => "MyText",
      :query_id => "Query",
      :query_name => "Query Name",
      :query_occurance => "Query Occurance",
      :version => "Version",
      :email_addr_pm_ack => "Email Addr Pm Ack",
      :email_addr_devel_ack => "Email Addr Devel Ack",
      :email_addr_qa_ack => "Email Addr Qa Ack",
      :send_email_pm_ack => false,
      :send_email_devel_ack => false,
      :send_email_qa_ack => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(/Query/)
    rendered.should match(/Query Name/)
    rendered.should match(/Query Occurance/)
    rendered.should match(/Version/)
    rendered.should match(/Email Addr Pm Ack/)
    rendered.should match(/Email Addr Devel Ack/)
    rendered.should match(/Email Addr Qa Ack/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
  end
end
