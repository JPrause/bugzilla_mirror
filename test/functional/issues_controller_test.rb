require 'test_helper'

class IssuesControllerTest < ActionController::TestCase
  setup do
    @issue = issues(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:issues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create issue" do
    assert_difference('Issue.count') do
      post :create, issue: { assigned_to: @issue.assigned_to, bz_id: @issue.bz_id, devel_ack: @issue.devel_ack, doc_ack: @issue.doc_ack, pm_ack: @issue.pm_ack, qa_ack: @issue.qa_ack, status: @issue.status, summary: @issue.summary, version: @issue.version, version_ack: @issue.version_ack }
    end

    assert_redirected_to issue_path(assigns(:issue))
  end

  test "should show issue" do
    get :show, id: @issue
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @issue
    assert_response :success
  end

  test "should update issue" do
    put :update, id: @issue, issue: { assigned_to: @issue.assigned_to, bz_id: @issue.bz_id, devel_ack: @issue.devel_ack, doc_ack: @issue.doc_ack, pm_ack: @issue.pm_ack, qa_ack: @issue.qa_ack, status: @issue.status, summary: @issue.summary, version: @issue.version, version_ack: @issue.version_ack }
    assert_redirected_to issue_path(assigns(:issue))
  end

  test "should destroy issue" do
    assert_difference('Issue.count', -1) do
      delete :destroy, id: @issue
    end

    assert_redirected_to issues_path
  end
end
