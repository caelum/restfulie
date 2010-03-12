require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class RestfulController < ApplicationController
  self.responder = Restfulie::Server::Controller::RestfulResponder

  def single
    response.last_modified = Time.utc(2008) if params[:last_modified]
    respond_with(AtomifiedModel.new(Time.utc(2009))
  end

  def collection
    respond_with [AtomifiedModel.new(Time.utc(2009)), AtomifiedModel.new(Time.utc(2008))]
  end

  def new_record
    model = AtomifiedModel.new(Time.utc(2009))
    model.new_record = true
    respond_with(model)
  end

  def empty
    respond_with []
  end
end

ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/:action/:id'
end

describe RestfulController, :type => :controller do
  tests RestfulieController
  
  before(:each) do
    @request.accept = "application/atom+xml"
  end
  
  context "single resource" do
    it "sets Last-Modified with resource.updated_at"
    it "returns 304 Not Modified if client's cache is still valid"
    it "refreshes Last-Modified if cache is expired"
    it "does not use cache in PUT requests"
    it "does not use cache in POST requests"
    it "does not set Etag"
    it "does not set cache for new records"
    it "does not set cache if Last-Modified is already in response"
  end
  
  context "collection" do
    it "sets Last-Modified using the latest updated_at"
    it "works with empty array"
  end
      
end