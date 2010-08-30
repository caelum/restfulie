require "spec_helper"

describe PaymentsController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/payments" }.should route_to(:controller => "payments", :action => "index")
    end

        it "recognizes and generates #new" do
      { :get => "/payments/new" }.should route_to(:controller => "payments", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/payments/1" }.should route_to(:controller => "payments", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/payments/1/edit" }.should route_to(:controller => "payments", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/payments" }.should route_to(:controller => "payments", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/payments/1" }.should route_to(:controller => "payments", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/payments/1" }.should route_to(:controller => "payments", :action => "destroy", :id => "1")
    end

  end
end
