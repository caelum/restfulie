require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

context Restfulie::Server::Base do
  
  context "while registering a mime type" do
    
    it "should be able to locate it" do
      class City
        extend Restfulie::MediaTypeControl
        media_type 'application/vnd.caelum_city+xml'
      end
      Restfulie::MediaType.media_type('application/vnd.caelum_city+xml').should == City
    end

    it "should be able to locate with encoding" do
      class City
        extend Restfulie::MediaTypeControl
        media_type 'application/vnd.caelum_city+xml'
      end
      Restfulie::MediaType.media_type('application/vnd.caelum_city+xml; charset=UTF-8').should == City
    end
    
    it "should throw an exception if not found" do
      lambda {Restfulie::MediaType.media_type('vnd/caelum_unknown_city+xml')}.should raise_error(Restfulie::UnsupportedContentType)
    end
    
    it "should notify when not supported" do
      class Country
        extend Restfulie::MediaTypeControl
        media_type 'vnd/country+xml'
      end
      Restfulie::MediaType.supports?('vnd/country+xml').should be_true
      Restfulie::MediaType.supports?('vnd/caelum_unknown_city+xml').should be_false
      lambda {Restfulie::MediaType.media_type('vnd/caelum_unknown_city+xml')}.should raise_error(Restfulie::UnsupportedContentType)
    end
    
    it "should be able to register more than one" do
      class City
        extend Restfulie::MediaTypeControl
        media_type 'application/vnd.caelum_city+xml', 'application/vnd.caelum_city+json'
      end
      Restfulie::MediaType.media_type('application/vnd.caelum_city+xml').should == City
      Restfulie::MediaType.media_type('application/vnd.caelum_city+json').should == City
    end
    
    it "should return the list of media types for a specific type" do
      class City
        extend Restfulie::MediaTypeControl
        media_type 'application/vnd.caelum_city+xml', 'application/vnd.caelum_city+json'
      end
      types = ['application/vnd.caelum_city+xml', 'application/vnd.caelum_city+json']
      verify(Restfulie::MediaType.medias_for(City), types)
    end
    
    it "should return the list of media types for a specific type with json and xml support" do
      class City
        extend Restfulie::MediaTypeControl
        media_type 'application/vnd.caelum_city+xml', 'application/vnd.caelum_city+json'
      end
      types = ['text/html','application/xml','application/json','xml','json','application/vnd.caelum_city+xml', 'application/vnd.caelum_city+json']
      verify(City.media_types, types)
    end
    
    def verify(all, expected)
      expected.each do |t|
        type = Restfulie::MediaType.media_types[t]
        all.include?(type).should be_true
      end
    end
    
    # move to server-side media type support only
    it "should invoke lambda if its a custom type" do
      l = mock Object
      l.should_receive :call
      type= Restfulie::MediaType.custom_type('name',Object, l)
      render_options = {}
      resource = Object.new
      options = Object.new
      controller = Object.new
      type.execute_for(controller, resource, options, render_options)
    end
    
    # move to server-side media type support only
    it "should execute and serialize the resource" do
      render_options = {}
      resource = Object.new
      options = Object.new
      controller = Object.new
      type = Restfulie::MediaType.rendering_type('content-type', String)
      resource.should_receive(:to_xml).with(options).and_return('content')
      type.should_receive(:format_name).at_least(1).and_return('xml')
      controller.should_receive(:render).with(render_options)
      type.execute_for(controller, resource, options, render_options)
      render_options[:content_type].should == 'content-type'
      render_options[:text].should == 'content'
    end
    
    # move to server-side media type support only
    it "should execute and use the resource if not json nor xml" do
      render_options = {}
      resource = Object.new
      options = Object.new
      controller = Object.new
      type = Restfulie::MediaType.rendering_type('content-type', String)
      type.should_receive(:format_name).at_least(1).and_return('else')
      controller.should_receive(:render).with(render_options)
      type.execute_for(controller, resource, options, render_options)
      render_options[:content_type].should == 'content-type'
      render_options[:text].should == resource
    end
    
  end
  
  context Restfulie::MediaType::Type do
    
    it "should translate /, . and + to _ when generating the short name" do
      Restfulie::MediaType.rendering_type('application/vnd.city+xml',String).short_name.should == 'application_vnd_city_xml'
    end
    
    it "should retrieve the format from the last part of the media type" do
      Restfulie::MediaType.rendering_type('vnd/city+xml',String).format_name.should == 'xml'
    end
    
    it "should retrieve the format if there is no +" do
      Restfulie::MediaType.rendering_type('xml',String).format_name.should == 'xml'
    end
    
    it "should retrieve the format if there is a /" do
      Restfulie::MediaType.rendering_type('application/xml',String).format_name.should == 'xml'
    end
    
  end
  
  context Restfulie::MediaType do
    
    it "should return the default handler if none is registered" do
      type = Object.new
      Restfulie::MediaType.should_receive(:supports?).with(type).and_return false
      Restfulie::MediaType.type_for(type).should == Restfulie::MediaType::DefaultMediaTypeDecoder
    end

    it "should return the overriden handler if none is registered" do
      type = Object.new
      handler = Object.new
      Restfulie::MediaType.should_receive(:supports?).with(type).and_return true
      Restfulie::MediaType.should_receive(:media_type).with(type).and_return handler
      Restfulie::MediaType.type_for(type).should == handler
    end
    
  end
  
end
