require "spec_helper"

describe SongsController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/songs" }.should route_to(:controller => "songs", :action => "index")
    end

        it "recognizes and generates #new" do
      { :get => "/songs/new" }.should route_to(:controller => "songs", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/songs/1" }.should route_to(:controller => "songs", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/songs/1/edit" }.should route_to(:controller => "songs", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/songs" }.should route_to(:controller => "songs", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/songs/1" }.should route_to(:controller => "songs", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/songs/1" }.should route_to(:controller => "songs", :action => "destroy", :id => "1")
    end

  end
end
