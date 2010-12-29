require 'spec_helper'

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

describe CreationController do
  
  context "creating a resource" do
    
    it "should return 201 with location" do
      request.accept = "application/atom+xml"
      
      uri = "http://newlocation.com/uri"
      
      controller.stub(:url_for).and_return uri

      post :create
      response.code.should == "201"
      response.headers["Location"].should == uri
    end

  end      
end
