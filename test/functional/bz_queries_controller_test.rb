require 'test_helper'

class BzQueriesControllerTest < ActionController::TestCase
  setup do
    @query = queries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:queries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create query" do
    assert_difference('BzQuery.count') do
      post :create, query: { bug_status: @query.bug_status, description: @query.description, flag: @query.flag, name: @query.name, output_format: @query.output_format, product: @query.product }
    end

    assert_redirected_to bz_query_path(assigns(:query))
  end

  test "should show query" do
    get :show, id: @query
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @query
    assert_response :success
  end

  test "should update query" do
    put :update, id: @query, query: { bug_status: @query.bug_status, description: @query.description, flag: @query.flag, name: @query.name, output_format: @query.output_format, product: @query.product }
    assert_redirected_to bz_query_path(assigns(:query))
  end

  test "should destroy query" do
    assert_difference('BzQuery.count', -1) do
      delete :destroy, id: @query
    end

    assert_redirected_to bz_queries_path
  end
end
