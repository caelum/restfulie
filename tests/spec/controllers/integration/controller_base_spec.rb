require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "action_controller"

describe RenderController do
  
  before(:each) do
    @object = Object.new
    @controller.stub!(:object).and_return(@object)
  end
  
  it "renders show action with application/atom+xml" do
    get :show, :id => 1
    @response.content_type.should == "application/atom+xml"
  end
  
  it "renders index action with application/atom+xml" do
    get :index
    @response.content_type.should == "application/atom+xml"
  end
  
  it "calls to_atom in show's object if object respond_to :to_atom" do
    @atom = Object.new
    @object.should_receive(:to_atom).once.and_return(@atom)
    @atom.should_receive(:to_xml).once
    get :show_with_mock, :id => 1
    @response.content_type.should == "application/atom+xml"
  end

  it "calls to_xml in show's object if object does not respond_to :to_atom" do
    @object.should_receive(:to_xml).once
    get :show_with_mock, :id => 1
    @response.content_type.should == "application/atom+xml"    
  end
  
end
