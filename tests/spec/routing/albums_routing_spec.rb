require "spec_helper"

describe AlbumsController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/albums" }.should route_to(:controller => "albums", :action => "index")
    end

        it "recognizes and generates #new" do
      { :get => "/albums/new" }.should route_to(:controller => "albums", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/albums/1" }.should route_to(:controller => "albums", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/albums/1/edit" }.should route_to(:controller => "albums", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/albums" }.should route_to(:controller => "albums", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/albums/1" }.should route_to(:controller => "albums", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/albums/1" }.should route_to(:controller => "albums", :action => "destroy", :id => "1")
    end

  end
end
