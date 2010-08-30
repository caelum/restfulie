require "spec_helper"

describe BasketsController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/baskets" }.should route_to(:controller => "baskets", :action => "index")
    end

        it "recognizes and generates #new" do
      { :get => "/baskets/new" }.should route_to(:controller => "baskets", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/baskets/1" }.should route_to(:controller => "baskets", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/baskets/1/edit" }.should route_to(:controller => "baskets", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/baskets" }.should route_to(:controller => "baskets", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/baskets/1" }.should route_to(:controller => "baskets", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/baskets/1" }.should route_to(:controller => "baskets", :action => "destroy", :id => "1")
    end

  end
end
