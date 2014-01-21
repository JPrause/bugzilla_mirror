require 'spec_helper'
require 'application_controller'

describe "issues/index" do
  before(:each) do
    assign(:issues, [
      stub_model(Issue,
        :bz_id       => "Bz",
        :dep_id      => "Dep",
        :status      => "Status",
        :summary     => "Summary",
        :assigned_to => "Assignee",
        :version     => "Version",
        :version_ack => "Version Ack",
        :pm_ack      => "Pm Ack",
        :devel_ack   => "Devel Ack",
        :qa_ack      => "Qa Ack",
        :doc_ack     => "Doc Ack"
      ),
      stub_model(Issue,
        :bz_id       => "Bz",
        :dep_id      => "Dep",
        :status      => "Status",
        :summary     => "Summary",
        :assigned_to => "Assignee",
        :version     => "Version",
        :version_ack => "Version Ack",
        :pm_ack      => "Pm Ack",
        :devel_ack   => "Devel Ack",
        :qa_ack      => "Qa Ack",
        :doc_ack     => "Doc Ack"
      )
    ])
  end

  context "#index" do
    it "renders a list of issues" do
      render
      assert_select "tr>td", :text => "Bz".to_s, :count => 2
      assert_select "tr>td", :text => "Status".to_s, :count => 2
      assert_select "tr>td", :text => "Assignee".to_s, :count => 2
      assert_select "tr>td", :text => "Summary".to_s, :count => 2
    end
  end
end
