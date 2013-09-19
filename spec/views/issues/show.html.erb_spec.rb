require 'spec_helper'

describe "issues/show" do
  before(:each) do
    @issue = assign(:issue, stub_model(Issue,
      :bz_id => "Bz",
      :status => "Status",
      :summary => "Summary",
      :version => "Version",
      :version_ack => "Version Ack",
      :pm_ack => "Pm Ack",
      :devel_ack => "Devel Ack",
      :qa_ack => "Qa Ack",
      :doc_ack => "Doc Ack"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Bz/)
    rendered.should match(/Status/)
    rendered.should match(/Summary/)
    rendered.should match(/Version/)
    rendered.should match(/Version Ack/)
    rendered.should match(/Pm Ack/)
    rendered.should match(/Devel Ack/)
    rendered.should match(/Qa Ack/)
    rendered.should match(/Doc Ack/)
  end
end
