require 'spec_helper'

describe DashboardController do

  describe "GET 'index'" do
    it "when #index returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'update_all'" do
    it "when #update_all returns http success" do
      Issue.stub(:update_from_bz).and_return("stub")
      Commit.stub(:update_from_git!)
      get 'update_all'
      response.should be_success
    end
  end

end
