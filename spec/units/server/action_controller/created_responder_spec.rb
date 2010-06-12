require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class ResponderWithCreated < ::ActionController::Responder
  include Restfulie::Server::ActionController::CreatedResponder
end

class CreationController < ApplicationController
  self.responder = ResponderWithCreated
  respond_to :atom

  def create
    @resource = Object.new
    respond_with @resource, :status => :created
  end

end

ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/:action/:id'
end

describe CreationController, :type => :controller do
  
  before(:each) do
    request.accept = "application/atom+xml"
  end
  
  context "creating a resource" do
    
    it "should return 201 with location" do
      uri = "http://newlocation.com/uri"
      controller.should_receive(:url_for).and_return uri
      post :create
      controller.response.code.should == "201"
      controller.response.headers["Location"].should == uri
    end

  end      
end
