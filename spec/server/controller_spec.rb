require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class BaseController
  attr_reader :rendered
  def render(options={})
    @rendered = options
  end
end

class ClientsController < BaseController
  include Restfulie::Server::Controller
end


context Restfulie::Server::Controller do
  
  before do
    @controller = ClientsController.new
  end

  context "when generic rendering a resource" do
  
    it "should invoke the original rendering process if there is no resource" do
      options = {:custom => :whatever}
      @controller.render(options)
      @controller.rendered.should eql(options)
    end
  
    it "should invoke render_resource if there is a resource to render" do
      resource = Object.new
      options = {:resource => resource, :with => {:custom => :whatever}}
      @controller.should_receive(:render_resource).with(resource, options[:with])
      @controller.render(options)
    end
  
  end


  context "when invoking render_resource" do
  
    it "should invoke to_xml with the specified parameters and controller" do
      resource = Object.new
      xml = "<resource />"
      options = {:custom => :whatever}
      resource.should_receive(:to_xml).with(options).and_return(xml)
      @controller.should_receive(:stale?).and_return(true)
      @controller.should_receive(:render).with({:xml=>"#{xml}"})
      @controller.render_resource(resource, options)
    end
    it "should not process if not stale" do
      @controller.should_receive(:stale?).and_return(false)
      @controller.render_resource(Object.new, {})
    end
  end

end