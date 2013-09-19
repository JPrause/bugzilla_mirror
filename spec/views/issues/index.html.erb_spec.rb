require 'spec_helper'

describe "issues/index" do
  before(:each) do
    assign(:issues, [
      stub_model(Issue,
        :bz_id => "Bz",
        :status => "Status",
        :summary => "Summary",
        :version => "Version",
        :version_ack => "Version Ack",
        :pm_ack => "Pm Ack",
        :devel_ack => "Devel Ack",
        :qa_ack => "Qa Ack",
        :doc_ack => "Doc Ack"
      ),
      stub_model(Issue,
        :bz_id => "Bz",
        :status => "Status",
        :summary => "Summary",
        :version => "Version",
        :version_ack => "Version Ack",
        :pm_ack => "Pm Ack",
        :devel_ack => "Devel Ack",
        :qa_ack => "Qa Ack",
        :doc_ack => "Doc Ack"
      )
    ])
  end

  it "renders a list of issues" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Bz".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "Summary".to_s, :count => 2
    assert_select "tr>td", :text => "Version".to_s, :count => 2
    assert_select "tr>td", :text => "Version Ack".to_s, :count => 2
    assert_select "tr>td", :text => "Pm Ack".to_s, :count => 2
    assert_select "tr>td", :text => "Devel Ack".to_s, :count => 2
    assert_select "tr>td", :text => "Qa Ack".to_s, :count => 2
    assert_select "tr>td", :text => "Doc Ack".to_s, :count => 2
  end
end
