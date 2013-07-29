require "spec_helper"

describe ReportTablesController do
  describe "routing" do

    it "routes to #index" do
      get("/report_tables").should route_to("report_tables#index")
    end

    it "routes to #new" do
      get("/report_tables/new").should route_to("report_tables#new")
    end

    it "routes to #show" do
      get("/report_tables/1").should route_to("report_tables#show", :id => "1")
    end

    it "routes to #edit" do
      get("/report_tables/1/edit").should route_to("report_tables#edit", :id => "1")
    end

    it "routes to #create" do
      post("/report_tables").should route_to("report_tables#create")
    end

    it "routes to #update" do
      put("/report_tables/1").should route_to("report_tables#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/report_tables/1").should route_to("report_tables#destroy", :id => "1")
    end

  end
end
