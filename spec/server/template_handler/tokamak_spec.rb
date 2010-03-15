require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class ProjectsController < ApplicationController
  self.responder = Restfulie::Server::Controller::RestfulResponder

  def index; end
  def show; end
  def new; end
end

describe ProjectsController, :type => :controller do
  tests ProjectsController
  integrate_views
  
  it "renders view files with tokamak extension" do
    get :index, :format => :atom
    response.body.should == "index.atom.tokamak"
  end
  
  it "renders view files without explicit format" do
    get :show, :format => :atom
    response.body.should == "show.tokamak"
  end
  
  it "prefers views with explicit format" do
    get :new, :format => :atom
    response.body.should == "new.atom.tokamak"  
  end
end