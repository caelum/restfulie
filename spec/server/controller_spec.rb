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
  
  context "when rendering a collection" do
    
    before do
      @collection = [1, 2]
    end
    
    it "should serialize and render a collection to atom" do
      content = Object.new
      @collection.should_receive(:to_atom).with(:title => "Clients", :controller => @controller).and_return content
      @controller.should_receive(:render_resource).with(@collection, nil, {:content_type => 'application/atom+xml', :text => content})
      @controller.render_collection @collection
    end
    
    it "should serialize in a custom way and render a collection to atom" do
      def @collection.to_atom(h, &block)
        raise "expected a block" if !block
        "custom content"
      end
      @controller.should_receive(:render_resource).with(@collection, nil, {:content_type => 'application/atom+xml', :text => "custom content"})
      @controller.render_collection @collection do |item|
        1+1
      end
    end
    
  end


  context "when invoking render_resource" do
    
    before do
      @info = {:hash_containing => "cache info"}
      @resource = Object.new
      @resource.should_receive(:cache_info).and_return(@info)
    end
  
    it "should invoke to_xml with the specified parameters and controller" do
      xml = "<resource />"
      options = {:custom => :whatever}
      @controller.should_receive(:stale?).with(@info).and_return(true)
      @controller.should_receive(:respond_to)
      @controller.render_resource(@resource, options)
    end
    
    it "should not process if not stale" do
      @controller.should_receive(:stale?).and_return(false)
      @controller.render_resource(@resource, {})
    end
  end
  
  context "when rendering a creation" do
    it "should set the location, code and render the resource" do
      resource = Object.new
      uri = "custom resource uri"
      @controller.should_receive(:url_for).with(resource).and_return(uri)
      @controller.should_receive(:render_resource).with(resource, {}, {:status => :created, :location => uri})
      @controller.render_created resource
    end
  end
  
  context "when rendering html" do
    it "should skip mime type checking when responds to html" do
      responder = ActionController::MimeResponds::RestfulieResponder.new
      @controller.should_receive(:mime_type_priority).and_return(["xml", "html"])
      
      responder.respond(@controller)
    end
    
    it "should not skip mime type checking when responds to html" do
      responder = ActionController::MimeResponds::RestfulieResponder.new
      @controller.should_receive(:mime_type_priority).and_return(["xml"])
      @controller.should_receive(:old_respond)
      responder.respond(@controller)
    end
  end

end