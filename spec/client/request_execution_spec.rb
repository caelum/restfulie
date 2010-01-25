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

class ClientRestfulieModel
  attr_accessor :content
  uses_restfulie
end


class ClientOrder
  attr_accessor :buyer
  uses_restfulie
end

context Restfulie::Client::Response do
  
  it "should enhance types by extending them with Web and Httpresponses" do
    result = Object.new
    response = Object.new
    final = Restfulie::Client::Response.new(nil, response).enhance(result)
    final.should == result
    final.should be_a(Restfulie::Client::WebResponse)
    final.web_response.should == response
    final.web_response.should be_a(Restfulie::Client::HTTPResponse)
  end
  
  context "parsing an entity" do
    
    class Shipment
    end
    
    before do
      @response = Hashi::CustomHash.new({"body" => "response body"})
      @result = Object.new
    end
    
    it "should complain about a generic type that doesnt match a from_ method" do
      @response.content_type = "custom_xhtml"
      lambda {Restfulie::Client::ResponseHandler.generic_parse_entity(restfulie_response)}.should raise_error(Restfulie::UnsupportedContentType)
    end
    
    it "should invoke a generic existing from_ method" do
      def Shipment.from_xhtml(content)
        "resulting content"
      end
      Restfulie::MediaType.should_receive(:type_for).with("xhtml").and_return(Shipment)
      @response.content_type = "xhtml"
      Restfulie::Client::ResponseHandler.generic_parse_entity(restfulie_response).should == "resulting content"
    end
    
    def restfulie_response(code = "200")
      @response.code = code
      Hashi::CustomHash.new({"response"=>@response})
    end
    
    it "should return a xml result from the content" do
      @response.content_type = "application/vnd.app+xml"
      Restfulie::MediaType.should_receive(:type_for).and_return(Shipment)
      Shipment.should_receive(:from_xml).with(@response.body).and_return(@result)
      Restfulie::Client::ResponseHandler.parse_entity(restfulie_response("200")).should == @result
    end
    
    it "should return a json result from the content" do
      @response.content_type = "application/json"
      Restfulie::MediaType.should_receive(:type_for).and_return(Shipment)
      Shipment.should_receive(:from_json).with(@response.body).and_return(@result)
      Restfulie::Client::ResponseHandler.parse_entity(restfulie_response("200")).should == @result
    end
    
    it "should return a generic result from the content" do
      @response.content_type = "xhtml"
      Restfulie::MediaType.should_receive(:type_for).and_return(Shipment)
      response = restfulie_response("200")
      Restfulie::Client::ResponseHandler.should_receive(:generic_parse_entity).with(response).and_return(@result)
      Restfulie::Client::ResponseHandler.parse_entity(response).should == @result
    end
    
  end
  
  context "posting" do
    
    it "should treat a 200 post as an enhanced 200 get response entity" do
      response = Object.new
      content = Object.new
      response.should_receive(:code).and_return("200")
      instance = Restfulie::Client::Response.new(NotFollow, response)
      entity = Object.new
      instance.should_receive(:final_parse).and_return(entity)
      result = instance.parse_post :nothing
      result.should == entity
    end

    it "should not follow moved permanently" do
      response = Object.new
      content = Object.new
      response.should_receive(:code).and_return("301")
      entity = Object.new
      instance = Restfulie::Client::Response.new(NotFollow, response)
      instance.should_receive(:final_parse).and_return(entity)
      result = instance.parse_post :nothing
      result.should == entity
    end

    it "should follow 301 if instructed to do so" do
      expected = Object.new
      location = "http://newuri"
      content = Object.new
      response = {"Location" => location}
      response.should_receive(:body).and_return(content)
      response.should_receive(:code).and_return("301")
      Follow.should_receive(:remote_post_to).with(location, content).and_return(expected)
      result = Restfulie::Client::Response.new(Follow, response).parse_post :nothing
      result.web_response.should == response
      result.should == expected
    end
  end
  
  class NotFollow
    def self.follows
      o = Object.new
      o.should_receive(:moved_permanently?).and_return(false)
      o
    end
  end
  class Follow
    def self.follows
      o = Object.new
      o.should_receive(:moved_permanently?).and_return(:all)
      o
    end
  end

end

context Restfulie::Client::RequestExecution do

  context "when preparing a state change" do
    
    before do
      @object = Object.new
      @instance = Restfulie::Client::RequestExecution.new(nil, @object)
    end
    
    it "should invoke a state change if there is a relation" do
      @object.should_receive(:existing_relations).and_return({"pay" => true})
      @instance.should_receive(:change_to_state).with("pay", [123])
      @instance.pay 123
    end
    
    it "should complain if there is no such state change" do
      @object.should_receive(:existing_relations).and_return({})
      lambda {@instance.pay 123}.should raise_error
    end
    
    it "should complain if its an entry point (no executing object)" do
      @instance = Restfulie::Client::RequestExecution.new(nil, nil)
      lambda {@instance.pay 123}.should raise_error
    end
    
    it "should add headers if there is nothing" do
      result = {}
      @instance.should_receive(:add_headers_to).with({}).and_return(result)
      @object.should_receive(:invoke_remote_transition).with(:name, [result])
      @instance.change_to_state(:name, [])
    end
    
    it "should add headers if there is data only" do
      result = {}
      @instance.should_receive(:add_headers_to).with({}).and_return(result)
      @object.should_receive(:invoke_remote_transition).with(:name, [123, result])
      @instance.change_to_state(:name, [123])
    end
    
    it "should add headers to hash if there is the last is a hash" do
      hash = {}
      result = {}
      @instance.should_receive(:add_headers_to).with(hash).and_return(result)
      @object.should_receive(:invoke_remote_transition).with(:name, [123,result])
      @instance.change_to_state(:name, [123, hash])
    end
    
    it "should add headers to hash if non-existent" do
      hash = {}
      @instance.as(:as).accepts(:accepts).add_headers_to(hash).should == hash
      hash[:headers]["Content-type"].should == :as
      hash[:headers]["Accept"].should == :accepts
    end
    
    it "should add headers to hash if existent" do
      hash = { :headers => {:already => :some_value}}
      @instance.as(:as).accepts(:accepts).add_headers_to(hash).should == hash
      hash[:headers]["Content-type"].should == :as
      hash[:headers]["Accept"].should == :accepts
      hash[:headers][:already].should == :some_value
    end
    
  end
  
  context "when executing a generic request" do
    
    before do
      @httpMethod = Object.new
      @http_request = Object.new
      @url = URI.parse "http://localhost" 
      
      @request = Restfulie::Client::RequestExecution.new(String, nil)
      @request.at("http://localhost/localhost")

      @request.should_receive(:prepare_request).with(@httpMethod, "delete", nil).and_return([@url, @http_request])
    end
    
    it "should execute the request and cache it" do
      response = Object.new

      http = Object.new
      http.should_receive(:request).with(@http_request).and_return(response)

      Restfulie.cache_provider.should_receive(:get).with(@url, @http_request).and_return(nil)
      should_parse_response response
      Net::HTTP.should_receive(:new).with("localhost", 80).and_return(http)
      Restfulie.cache_provider.should_receive(:put).with(@url, @http_request, response)
      
      @request.do(@httpMethod, "delete", nil)
    end
    
    it "should not execute the request when the cache contains it" do
      cached_response = Object.new
      Restfulie.cache_provider.should_receive(:get).with(@url, @http_request).and_return(cached_response)
      should_parse_response cached_response
      @request.do(@httpMethod, "delete", nil).should == "result"
    end
    
    def should_parse_response(response)
      responder = Object.new
      Restfulie::Client::Response.should_receive(:new).with(String, response).and_return(responder)
      responder.should_receive(:parse).with(@httpMethod, nil, "application/xml").and_return("result")      
    end
    
  end

  context "preparing a request" do
  
    before do
      @httpMethod = Object.new
      @req = Object.new
      @httpMethod.should_receive(:new).with("/localhost").and_return(@req)
    
      @request = Restfulie::Client::RequestExecution.new(String, nil)
      @request.should_receive(:add_basic_request_headers).with(@req, "delete")
    end
  
    it "should add headers to the request" do
      prepare_and_verify_request
    end
  
    it "should add post data if it is a post" do
      @req.should_receive(:body=).with("content")
      @req.should_receive(:get_fields).with("Content-type").and_return("txt")
      prepare_and_verify_request "content"
    end
  
    it "should use the default post content type if none is provided" do
      @req.should_receive(:body=).with("content")
      @req.should_receive(:get_fields).with("Content-type").and_return(nil)
      @req.should_receive(:add_field).with("Content-type", "application/xml")
      prepare_and_verify_request "content"
    end
    
    def prepare_and_verify_request (content = nil)
      url, req = @request.at("http://localhost/localhost").prepare_request(@httpMethod, "delete", content)
      req.should == @req
    end

  end

  def define_http_expectation(req, mock_response)
    http = mock Net::HTTP
    Net::HTTP.should_receive(:new).with('www.caelumobjects.com', 80).and_return(http)
    http.should_receive(:request).with(req).and_return(mock_response)
    http
  end

  context "when creating" do
    it "should post" do
      content = "content to post"
      execution = Restfulie::Client::RequestExecution.new(nil, nil)
      execution.should_receive(:post).with(content)
      execution.create(content)
    end
  end
  
  context "when posting" do
  	
  	before do
      @content = "custom content"
      @req = expect_request('/product')
      @mock_response = mock Net::HTTPResponse
    end
    
    def expect_request(uri)
      req = mock Net::HTTP::Post
      Net::HTTP::Post.should_receive(:new).with(uri).and_return(req)
      req.should_receive(:body=).with(@content)
      req.should_receive(:add_field).with("Content-type", "application/xml")
      req
    end
    
    it "invoke parse post content, create the post request, and return its content" do
      define_http_expectation(@req, @mock_response)

      parsed_result = Object.new
      result = mock Restfulie::Client::Response
      result.should_receive(:parse_post).and_return(parsed_result)
      Restfulie::Client::Response.should_receive(:new).and_return(result)
      req = Restfulie::Client::RequestExecution.new(ClientOrder, nil)
      req.should_receive(:add_basic_request_headers)
      res = req.at('http://www.caelumobjects.com/product').create @content
      res.should == parsed_result
    end

  end
  
  context "when retrieving" do

    def expect_request(uri)
      req = mock Net::HTTP::Get
      Net::HTTP::Get.should_receive(:new).with(uri).and_return(req)
      req
    end

    it "should allow setting what to accept" do
      result = Object.new
      
      req = expect_request('/product')
      res = Hashi::CustomHash.new({})
      define_http_expectation(req, res)
      response = Object.new
      response.should_receive(:final_parse).and_return(result)
      Restfulie::Client::Response.should_receive(:new).with(String, res).and_return(response)
      ex = Restfulie::Client::RequestExecution.new(String, nil)
      ex.should_receive(:add_basic_request_headers)
      ex.at('http://www.caelumobjects.com/product').accepts('vnd/product+xml').get.should == result
    end
    
  end

  context "when de-serializing straight from a web request" do
    
    def mock_request_for(type)
      res = Object.new
      @response = res
      req = mock Net::HTTPRequest
      req.should_receive(:add_field).with('Accept', 'application/xml')
      req.stub(:get_fields).and_return(nil)
      Net::HTTP::Get.should_receive(:new).with('/order/15').and_return(req)
      http = Object.new
      Net::HTTP.should_receive(:new).with('localhost',3001).and_return(http)
      http.should_receive(:request).with(req).and_return(res)
    end
    
    it "should deserialize correctly if its an xml" do
      mock_request_for "application/xml"
      result = Object.new
      Restfulie::Client::ResponseHandler.should_receive(:handle).with(@response).and_return(result)
      
      model = ClientRestfulieModel.from_web 'http://localhost:3001/order/15'
      model.should == result
    end
    
    it "should enhance the result adding the response" do
      mock_request_for "application/xml"
      result = Object.new
      Restfulie::Client::ResponseHandler.should_receive(:handle).with(@response).and_return(result)
  
      model = ClientRestfulieModel.from_web 'http://localhost:3001/order/15'
      model.web_response.should == @response
    end

  end
  
  context "when adding headers" do
    
    it "should add accepts if there is none" do
      @req = Object.new
      @origin = Object.new
      @ex = Restfulie::Client::RequestExecution.new(String, @origin).accepts("nothing")
      @origin.should_receive(:_came_from).and_return("html")
      @req.stub(:get_fields).and_return(["*/*"])
      @req.should_receive(:add_field).with("Accept", "nothing")
      @req.should_receive(:add_field).with("Accept", "html")
      @ex.add_basic_request_headers(@req, nil)
    end
    
    before do
      @req = Object.new
      @origin = Hashi::CustomHash.new
      @ex = Restfulie::Client::RequestExecution.new(String, @origin).accepts("nothing")
      def @origin.web_response
        self
      end
    end
    
    it "should add Accepts if its there" do
      @req.should_receive(:add_field).with("Accept", "nothing")
      @req.stub(:get_fields).and_return(nil)
      @ex.add_basic_request_headers(@req, nil)
    end
    
    it "should add every header available" do
      @req.should_receive(:add_field).with("Accept", "nothing")
      @req.should_receive(:add_field).with("name", "value")
      @req.stub(:get_fields).and_return(nil)
      @ex.with({"name" => "value"}).add_basic_request_headers(@req, nil)
    end
        
    it "should add etag if available" do
      @origin.etag = "custom etag"
      @origin.last_modified = nil
      @req.should_receive(:add_field).with("Accept", "nothing")
      @req.should_receive(:add_field).with("If-None-Match", "custom etag")
      @req.stub(:get_fields).and_return(nil)
      String.should_receive(:is_self_retrieval?).with("custom").and_return(true)
      @ex.add_basic_request_headers(@req, "custom")
    end
    
    it "should add last modified if available" do
      @origin.etag = nil
      @origin.last_modified = "date"
      @req.should_receive(:add_field).with("Accept", "nothing")
      @req.should_receive(:add_field).with("If-Modified-Since", "date")
      @req.stub(:get_fields).and_return(nil)
      String.should_receive(:is_self_retrieval?).with("custom").and_return(true)
      @ex.add_basic_request_headers(@req, "custom")
    end
    
  end
  
  context "when handling responses" do
    
    it "should return the response when its a pure response return" do
      response = Object.new
      restfulie_response = Hashi::CustomHash.new({"response" => response})
      result = Restfulie::Client::ResponseHandler.pure_response_return(restfulie_response)
      result.should == response
    end

    it "should raise an error if raise_error is invoked" do
      response = Object.new
      restfulie_response = Hashi::CustomHash.new({"response" => response})
      lambda {Restfulie::Client::ResponseHandler.raise_error(restfulie_response)}.should raise_error(Restfulie::Client::ResponseError)
    end
    
    class CustomResource
    end
    
    it "should execute a from web request when retrieveing a resource as a result" do
      expected = Object.new
      
      response = {"Location" => "google"}
      restfulie_response = Restfulie::Client::Response.new(CustomResource, response)
      CustomResource.should_receive(:from_web).with("google").and_return(expected)
      result = Restfulie::Client::ResponseHandler.retrieve_resource_from_location(restfulie_response)
      result.should == expected
    end

    it "should test registering and using a specific handler" do
      result = false
      Restfulie::Client::ResponseHandler.register(100,100) do |response|
        result = true
      end
      response = Hashi::CustomHash.new({"response" => {"code" => "100"}})
      Restfulie::Client::ResponseHandler.handle(response)
      result.should be_true
    end
    
    it "should test overriding and using a specific handler" do
      result = false
      Restfulie::Client::ResponseHandler.register(300,300) do |response|
        result = false
      end
      Restfulie::Client::ResponseHandler.register(300,300) do |response|
        result = true
      end
      response = Hashi::CustomHash.new({"response" => {"code" => "300"}})
      Restfulie::Client::ResponseHandler.handle(response)
      result.should be_true
    end
    
    it "should test default handlers for 200" do
      response = Hashi::CustomHash.new({"response" => {"code" => "200"}})
      Restfulie::Client::ResponseHandler.should_receive(:parse_entity).with(response)
      Restfulie::Client::ResponseHandler.handle(response)
    end
    
    it "should test default handlers for 301" do
      response = Hashi::CustomHash.new({"response" => {"code" => "301"}})
      Restfulie::Client::ResponseHandler.should_receive(:retrieve_resource_from_location).with(response)
      Restfulie::Client::ResponseHandler.handle(response)
    end
    
  end

end