require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class ClientsController < ActionController::Base
end

context ActionController::Base do
  
  before do
    @controller = ClientsController.new
  end

  context "when generic rendering a resource" do
  
    it "should invoke the original rendering process if there is no resource" do
      resource = Object.new
      @controller.should_receive(:old_render)
      @controller.render :xml => resource
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
  
  context "when rendering a creation" do
    it "should set the location, code and render the resource" do
      resource = Object.new
      uri = "custom resource uri"
      @controller.should_receive(:url_for).with(resource).and_return(uri)
      @controller.should_receive(:render_resource).with(resource, {}, {:code => 201, :location => uri})
      @controller.render_created resource
    end
  end

end