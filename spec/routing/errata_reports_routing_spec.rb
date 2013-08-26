require "spec_helper"

describe ErrataReportsController do
  describe "routing" do

    it "routes to #index" do
      get("/errata_reports").should route_to("errata_reports#index")
    end

    it "routes to #new" do
      get("/errata_reports/new").should route_to("errata_reports#new")
    end

    it "routes to #show" do
      get("/errata_reports/1").should route_to("errata_reports#show", :id => "1")
    end

    it "routes to #edit" do
      get("/errata_reports/1/edit").should route_to("errata_reports#edit", :id => "1")
    end

    it "routes to #create" do
      post("/errata_reports").should route_to("errata_reports#create")
    end

    it "routes to #update" do
      put("/errata_reports/1").should route_to("errata_reports#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/errata_reports/1").should route_to("errata_reports#destroy", :id => "1")
    end

  end
end
