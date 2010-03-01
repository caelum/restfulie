#
#  Copyright (c) 2009 Caelum - www.caelum.com.br/opensource
#  All rights reserved.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); 
#  you may not use this file except in compliance with the License. 
#  You may obtain a copy of the License at 
#  
#   http://www.apache.org/licenses/LICENSE-2.0 
#  
#  Unless required by applicable law or agreed to in writing, software 
#  distributed under the License is distributed on an "AS IS" BASIS, 
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
#  See the License for the specific language governing permissions and 
#  limitations under the License. 
#

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
    
    it "should invoke to_xml with the specified parameters and controller" do
      resource = Object.new
      @controller.should_receive(:handle_cache_headers).with(resource).and_return(true)
      xml = "<resource />"
      options = {:custom => :whatever}
      @controller.should_receive(:respond_to)
      @controller.render_resource(resource, options)
    end
    
  end
  
  context "when dealing with cache headers" do
    
    it "should add cache to use max age and return whether the representation is stale" do
      @info = {:hash_containing => "cache info"}
      @resource.should_receive(:cache_info).and_return(@info)
      
      cache = Object.new
      cache.should_receive(:max_age).and_return(15)
      @controller.should_receive(:cache_to_use).and_return(cache)

      response = Object.new
      @controller.should_receive(:response).and_return(response)
      headers = mock Hash
      headers.should_receive(:[]=).with("Cache-control", "max-age=15")
      response.should_receive(:headers).and_return(headers)
      
      @controller.should_receive(:stale?).with(@info).and_return(false)
      @controller.handle_cache_headers(@resource).should == false
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