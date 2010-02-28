# Copyright (c) 2008 The Kaphan Foundation
#
# For licensing information see LICENSE.txt.
#
# Please visit http://www.peerworks.org/contact for further information.
#

require File.dirname(__FILE__) + '/../spec_helper'
require 'atom'
require 'atom/pub'
require 'atom/version'
require 'uri'
require 'net/http'

shared_examples_for 'parser of spec/app/service.xml' do
  it "should have 2 workspaces" do
    @service.should have(2).workspaces
  end
    
  it "should have a title" do
    @workspace.title.should == "Main Site"
  end

  it "should have 2 collections" do
    @workspace.should have(2).collections
  end

  it "should have the right href" do
    @collection1.href.should == 'http://example.org/blog/main'
  end

  it "should have categories" do
    @collection1.categories.should_not be_nil
  end
  
  it "should have a href on categories" do 
    @collection1.categories.href.should == "http://example.com/cats/forMain.cats"
    @collection1.categories.fixed?.should be_false
  end
  
  it "should have a title" do
    @collection1.title.should == 'My Blog Entries'
  end
  
  it "should have a title" do
    @collection2.title.should == 'Pictures'
  end

  it "should have the right href" do
    @collection2.href.should == 'http://example.org/blog/pic'
  end

  it "should not have categories" do
    @collection2.categories.should be_nil
  end

  it "should have 3 accepts" do
    @collection2.should have(3).accepts
  end

  it "should accept 'image/png'" do
    @collection2.accepts.should include('image/png')
  end

  it "should accept 'image/jpeg'" do
    @collection2.accepts.should include('image/jpeg')
  end

  it "should accept 'image/gif'" do
    @collection2.accepts.should include('image/gif')
  end
  
  it "should have a title on workspace 2" do
    @workspace2.title.should == 'Sidebar Blog'
  end

  it "should have 1 collection on workspace 2" do
    @workspace2.should have(1).collections
  end

  it "should have a title on collection 3" do
    @collection3.title.should == 'Remaindered Links'
  end

  it "should have 1 accept on collection 3" do
    @collection3.should have(1).accepts
  end

  it "should accept 'application/atom+xml;type=entry'" do
    @collection3.accepts.should include('application/atom+xml;type=entry')
  end

  it "should have categories" do
    @collection3.categories.should_not be_nil
  end
  
  it "should have fixed == 'yes' on categories" do
    @collection3.categories.fixed.should == "yes"
  end
  
  it "should have fixed? == true on categories" do
    @collection3.categories.fixed?.should be_true
  end
end

describe Atom::Pub do  
  describe Atom::Pub::Service do
    it "should load from a URL" do
      uri = URI.parse('http://example.com/service.xml')
      response = Net::HTTPSuccess.new(nil, nil, nil)
      response.stub!(:body).and_return(File.read('spec/app/service.xml'))
      mock_http_get(uri, response)
      
      Atom::Pub::Service.load_service(uri).should be_an_instance_of(Atom::Pub::Service)
    end
    
    it "should raise ArgumentError with a non-http URL" do
      lambda { Atom::Pub::Service.load_service(URI.parse('file:/tmp')) }.should raise_error(ArgumentError)
    end
    
    it "should be able to be created without xml" do
      lambda { Atom::Pub::Service.new }.should_not raise_error
    end
    
    it "should yield in the initializer" do
      yielded = false
      Atom::Pub::Service.new do
        yielded = true
      end
      
      yielded.should be_true
    end

    it "should parse it's output" do
      orig = File.read('spec/app/service.xml')
      svc = Atom::Pub::Service.load_service(orig)
      xml = svc.to_xml
      lambda do
        Atom::Pub::Service.load_service(xml)
      end.should_not raise_error
    end
        
    describe "load_service" do
      before(:all) do
        @service = Atom::Pub::Service.load_service(File.open('spec/app/service.xml'))
        @workspace = @service.workspaces.first
        @workspace2 = @service.workspaces[1]
        @collection1 = @workspace.collections.first
        @collection2 = @workspace.collections[1]
        @collection3 = @workspace2.collections.first
      end
      
      it_should_behave_like 'parser of spec/app/service.xml'
    end
    
    describe "load_service with authentication" do
      it "should pass credentials to the server" do
        uri = URI.parse('http://example.com/service.xml')
        response = Net::HTTPSuccess.new(nil, nil, nil)
        response.stub!(:body).and_return(File.read('spec/app/service.xml'))
        mock_http_get(uri, response, 'user', 'pass')
        Atom::Pub::Service.load_service(uri, :user => 'user', :pass => 'pass')
      end
      
      it "should pass credentials on to the collections" do
        uri = URI.parse('http://example.com/service.xml')
        response = Net::HTTPSuccess.new(nil, nil, nil)
        response.stub!(:body).and_return(File.read('spec/app/service.xml'))
        mock_http_get(uri, response, 'user', 'pass')
        pub = Atom::Pub::Service.load_service(uri, :user => 'user', :pass => 'pass')
                
        uri2 = URI.parse('http://example.org/blog/main')
        response2 = Net::HTTPSuccess.new(nil, nil, nil)
        response2.stub!(:body).and_return(File.read('spec/fixtures/simple_single_entry.atom'))
        mock_http_get(uri2, response2, 'user', 'pass')
        pub.workspaces.first.collections.first.feed(:user => 'user', :pass => 'pass')
      end      
    end
    
    describe "#to_xml" do
      before(:each) do
        @svc = Atom::Pub::Service.load_service(File.read('spec/app/service.xml'))
        @xml = @svc.to_xml
        @service = Atom::Pub::Service.load_service(@xml)
        @workspace = @service.workspaces.first
        @workspace2 = @service.workspaces[1]
        @collection1 = @workspace.collections.first
        @collection2 = @workspace.collections[1]
        @collection3 = @workspace2.collections.first
      end
    
      it "should put title in Atom namespace" do
        @xml.should match(%r{atom:title})
      end
      
      it_should_behave_like 'parser of spec/app/service.xml'
    end
  end
  
  describe Atom::Pub::Collection do    
    describe '.new' do    
      it "should set the href from the hash" do
        collection = Atom::Pub::Collection.new(:href => 'http://example.org/blog')
        collection.href.should == 'http://example.org/blog'
      end
      
      it "should set the href from a block" do
        collection = Atom::Pub::Collection.new do |c|
          c.href = "http://example.org/blog"
        end
        collection.href.should == 'http://example.org/blog'
      end
    end
    
    it "should return the feed" do
      collection = Atom::Pub::Collection.new(:href => 'http://example.org/blog')
      response = Net::HTTPSuccess.new(nil, nil, nil)
      response.stub!(:body).and_return(File.read('spec/fixtures/simple_single_entry.atom'))
      mock_http_get(URI.parse(collection.href), response)
      collection.feed.should be_an_instance_of(Atom::Feed)
    end
     
    describe '#publish' do 
      before(:each) do
        @collection = Atom::Pub::Collection.new(:href => 'http://example.org/blog')
        @request_headers = {'Accept' => 'application/atom+xml', 
                   'Content-Type' => 'application/atom+xml;type=entry',
                   'User-Agent' => "rAtom #{Atom::VERSION::STRING}"
                   }
      end
          
      it "should send a POST request when an entry is published" do      
        entry = Atom::Entry.load_entry(File.open('spec/fixtures/entry.atom'))      
                 
        response = mock_response(Net::HTTPCreated, entry.to_xml.to_s)
      
        request = mock('request')
        Net::HTTP::Post.should_receive(:new).with('/blog', @request_headers).and_return(request)
        
        http = mock('http')
        http.should_receive(:request).with(request, entry.to_xml.to_s).and_return(response)
        Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)
      
        created = @collection.publish(entry)
        created.should == entry
      end
      
      it "should send a POST with basic auth request when an entry is published" do      
        entry = Atom::Entry.load_entry(File.open('spec/fixtures/entry.atom'))      
                 
        response = mock_response(Net::HTTPCreated, entry.to_xml.to_s)
      
        request = mock('request')
        request.should_receive(:basic_auth).with('user', 'pass')
        Net::HTTP::Post.should_receive(:new).with('/blog', @request_headers).and_return(request)
        
        http = mock('http')
        http.should_receive(:request).with(request, entry.to_xml.to_s).and_return(response)
        Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)
      
        created = @collection.publish(entry, :user => 'user', :pass => 'pass')
        created.should == entry
      end
      
      if Atom::Configuration.auth_hmac_enabled?
        it "should send a POST with hmac authentication when an entry is published" do  
          entry = Atom::Entry.load_entry(File.open('spec/fixtures/entry.atom'))      
                 
          response = mock_response(Net::HTTPCreated, entry.to_xml.to_s)
              
          http = mock('http')
          http.should_receive(:request) do |request, entry_xml|
            request['Authorization'].should match(/^AuthHMAC access_id:[a-zA-Z0-9\/+]+=*/)
            response
          end
            
          Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)
      
          created = @collection.publish(entry, :hmac_access_id => 'access_id', :hmac_secret_key => 'secret')
          created.should == entry
        end
      else
        xit "should send a POST with hmac authentication when an entry is published"
      end
    
      it "should behave well when no content is returned" do      
        entry = Atom::Entry.load_entry(File.open('spec/fixtures/entry.atom'))      
                 
        response = mock_response(Net::HTTPCreated, " ")
      
        request = mock('request')
        Net::HTTP::Post.should_receive(:new).with('/blog', @request_headers).and_return(request)
        
        http = mock('http')
        http.should_receive(:request).with(request, entry.to_xml.to_s).and_return(response)
        Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)
      
        created = @collection.publish(entry)
        created.should == entry
      end
    
      it "should raise error when response is not HTTPCreated" do
        entry = Atom::Entry.load_entry(File.open('spec/fixtures/entry.atom'))
        response = mock_response(Net::HTTPPreconditionFailed, "")
      
        request = mock('request')
        Net::HTTP::Post.should_receive(:new).with('/blog', @request_headers).and_return(request)
        
        http = mock('http')
        http.should_receive(:request).with(request, entry.to_xml.to_s).and_return(response)
        Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)
      
        lambda { @collection.publish(entry) }.should raise_error(Atom::Pub::ProtocolError)
      end
    
      it "should copy Location into edit link of entry" do
        entry = Atom::Entry.load_entry(File.open('spec/fixtures/entry.atom'))      
                 
        response = mock_response(Net::HTTPCreated, entry.to_xml.to_s, 'Location' => 'http://example.org/edit/entry1.atom')
      
        request = mock('request')
        Net::HTTP::Post.should_receive(:new).with('/blog', @request_headers).and_return(request)
        
        http = mock('http')
        http.should_receive(:request).with(request, entry.to_xml.to_s).and_return(response)
        Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)
      
        created = @collection.publish(entry)
        created.edit_link.should_not be_nil
        created.edit_link.href.should == 'http://example.org/edit/entry1.atom'
      end
    
      it "should update the entry when response is different" do
        entry = Atom::Entry.load_entry(File.open('spec/fixtures/entry.atom'))
        response = mock_response(Net::HTTPCreated, File.read('spec/fixtures/created_entry.atom'),
                                 'Location' => 'http://example.org/edit/atom')
      
        request = mock('request')
        Net::HTTP::Post.should_receive(:new).with('/blog', @request_headers).and_return(request)

        http = mock('http')
        http.should_receive(:request).with(request, entry.to_xml.to_s).and_return(response)
        Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)
      
        created = @collection.publish(entry)
        created.should == Atom::Entry.load_entry(File.open('spec/fixtures/created_entry.atom'))
      end
    end
  end
  
  describe Atom::Pub::Workspace do
    it "should do the block initialization thing" do
      workspace = Atom::Pub::Workspace.new do |w|
        w.title = "Title"
      end
      
      workspace.title.should == "Title"
    end
    
    it "should do the hash initialization thing" do
      workspace = Atom::Pub::Workspace.new(:title => 'Title')      
      workspace.title.should == "Title"
    end
  end
  
  describe Atom::Entry do
    before(:each) do
      @request_headers = {'Accept' => 'application/atom+xml', 
                          'Content-Type' => 'application/atom+xml;type=entry',
                          'User-Agent' => "rAtom #{Atom::VERSION::STRING}"
                         }
    end
    
    it "should send a PUT to the edit link on save!" do
      entry = Atom::Entry.load_entry(File.open('spec/app/member_entry.atom'))
      response = mock_response(Net::HTTPSuccess, nil)
      
      request = mock('request')
      Net::HTTP::Put.should_receive(:new).with('/member_entry.atom', @request_headers).and_return(request)

      http = mock('http')
      http.should_receive(:request).with(request, entry.to_xml.to_s).and_return(response)
      Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)
            
      entry.save!
    end
    
    it "should send a PUT with auth to the edit link on save!" do
      entry = Atom::Entry.load_entry(File.open('spec/app/member_entry.atom'))
      response = mock_response(Net::HTTPSuccess, nil)
      
      request = mock('request')
      request.should_receive(:basic_auth).with('user', 'pass')
      Net::HTTP::Put.should_receive(:new).with('/member_entry.atom', @request_headers).and_return(request)

      http = mock('http')
      http.should_receive(:request).with(request, entry.to_xml.to_s).and_return(response)
      Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)
            
      entry.save!(:user => 'user', :pass => 'pass')
    end
    
    if Atom::Configuration.auth_hmac_enabled?
      it "should send a PUT with hmac auth to the edit link on save!" do
        entry = Atom::Entry.load_entry(File.open('spec/app/member_entry.atom'))
        response = mock_response(Net::HTTPSuccess, nil)
      
        http = mock('http')
        http.should_receive(:request) do |request, entry_xml|
          request['Authorization'].should match(/^AuthHMAC access_id:[a-zA-Z0-9\/+]+=*$/)
          response
        end
        
        Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)
            
        entry.save!(:hmac_access_id => 'access_id', :hmac_secret_key => 'secret')
      end
    end
    
    it "should send a DELETE to the edit link on delete!" do
      entry = Atom::Entry.load_entry(File.open('spec/app/member_entry.atom'))
      response = mock_response(Net::HTTPSuccess, nil)
      
      request = mock('request')
      Net::HTTP::Delete.should_receive(:new).with('/member_entry.atom', an_instance_of(Hash)).and_return(request)

      http = mock('http')
      http.should_receive(:request).with(request).and_return(response)
      Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)
      
      entry.destroy!
    end
    
    it "should send a DELETE with basic auth to the edit link on delete!" do
      entry = Atom::Entry.load_entry(File.open('spec/app/member_entry.atom'))
      response = mock_response(Net::HTTPSuccess, nil)

      request = mock('request')
      request.should_receive(:basic_auth).with('user', 'pass')
      Net::HTTP::Delete.should_receive(:new).with('/member_entry.atom', an_instance_of(Hash)).and_return(request)

      http = mock('http')
      http.should_receive(:request).with(request).and_return(response)
      Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)

      entry.destroy!(:user => 'user', :pass => 'pass')
    end
    
    if Atom::Configuration.auth_hmac_enabled?
      it "should send a DELETE with hmac auth to the edit link on delete!" do
        entry = Atom::Entry.load_entry(File.open('spec/app/member_entry.atom'))
        response = mock_response(Net::HTTPSuccess, nil)

        http = mock('http')
        http.should_receive(:request) do |request|
          request['Authorization'].should match(/^AuthHMAC access_id:[a-zA-Z0-9\/+]+=*$/)
          response
        end
        
        Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)

        entry.destroy!(:hmac_access_id => 'access_id', :hmac_secret_key => 'secret')
      end
    end
    
    it "should raise exception on save! without an edit link" do
      entry = Atom::Entry.load_entry(File.open('spec/fixtures/entry.atom'))
      lambda { entry.save! }.should raise_error(Atom::Pub::NotSupported)
    end
    
    it "should raise exception on save failure" do
      entry = Atom::Entry.load_entry(File.open('spec/app/member_entry.atom'))
      response = mock_response(Net::HTTPClientError, nil)
      
      request = mock('request')
      Net::HTTP::Put.should_receive(:new).with('/member_entry.atom', @request_headers).and_return(request)

      http = mock('http')
      http.should_receive(:request).with(request, entry.to_xml.to_s).and_return(response)
      Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)
      
      lambda { entry.save! }.should raise_error(Atom::Pub::ProtocolError)
    end
    
    it "should raise exception on destroy! without an edit link" do
      entry = Atom::Entry.load_entry(File.open('spec/fixtures/entry.atom'))
      lambda { entry.destroy! }.should raise_error(Atom::Pub::NotSupported)
    end
    
    it "should raise exception on destroy failure" do
      entry = Atom::Entry.load_entry(File.open('spec/app/member_entry.atom'))
      response = mock_response(Net::HTTPClientError, nil)
      
      request = mock('request')
      Net::HTTP::Delete.should_receive(:new).with('/member_entry.atom', an_instance_of(Hash)).and_return(request)

      http = mock('http')
      http.should_receive(:request).with(request).and_return(response)
      Net::HTTP.should_receive(:start).with('example.org', 80).and_yield(http)
      
      lambda { entry.destroy! }.should raise_error(Atom::Pub::ProtocolError)
    end
  end
end
