require 'spec_helper'

describe "issues/edit" do
  before(:each) do
    @issue = assign(:issue, stub_model(Issue,
      :bz_id => "MyString",
      :status => "MyString",
      :summary => "MyString",
      :version => "MyString",
      :version_ack => "MyString",
      :pm_ack => "MyString",
      :devel_ack => "MyString",
      :qa_ack => "MyString",
      :doc_ack => "MyString"
    ))
  end

  it "renders the edit issue form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", issue_path(@issue), "post" do
      assert_select "input#issue_bz_id[name=?]", "issue[bz_id]"
      assert_select "input#issue_status[name=?]", "issue[status]"
      assert_select "input#issue_summary[name=?]", "issue[summary]"
      assert_select "input#issue_version[name=?]", "issue[version]"
      assert_select "input#issue_version_ack[name=?]", "issue[version_ack]"
      assert_select "input#issue_pm_ack[name=?]", "issue[pm_ack]"
      assert_select "input#issue_devel_ack[name=?]", "issue[devel_ack]"
      assert_select "input#issue_qa_ack[name=?]", "issue[qa_ack]"
      assert_select "input#issue_doc_ack[name=?]", "issue[doc_ack]"
    end
  end
end
