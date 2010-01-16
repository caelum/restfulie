require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class ClientRestfulieModel < ActiveRecord::Base
  attr_accessor :content
  uses_restfulie
end


class ClientOrder < ActiveRecord::Base
  attr_accessor :buyer
  uses_restfulie
end

context Restfulie::Client::Response do
  
  it "should enhance types by extending them with Web and Httpresponses" do
    result = Object.new
    response = Object.new
    final = Restfulie::Client::Response.new(nil, response).enhance(result)
    final.should == result
    final.is_a?(Restfulie::Client::WebResponse).should be_true
    final.web_response.should == response
    final.web_response.is_a?(Restfulie::Client::HTTPResponse).should be_true
  end
  
  context "parsing an entity" do
    
    class Shipment
    end
    
    before do
      @response = Hashi::CustomHash.new({"body" => "response body"})
      @instance = Restfulie::Client::Response.new(nil, @response)
      @result = Object.new
    end
    
    it "should complain about a generic type that doesnt match a from_ method" do
      lambda {@instance.generic_parse_get_entity("html", Shipment)}.should raise_error(Restfulie::UnsupportedContentType)
    end
    
    it "should invoke a generic existing from_ method" do
      def Shipment.from_xhtml(content)
        "resulting content"
      end
      @instance.generic_parse_get_entity("xhtml", Shipment).should == "resulting content"
    end
    
    it "should return a xml result from the content" do
      @response.content_type = "application/vnd.app+xml"
      Restfulie::MediaType.should_receive(:type_for).and_return(Shipment)
      Shipment.should_receive(:from_xml).with(@response.body).and_return(@result)
      @instance.parse_get_entity("200").should == @result
    end
    
    it "should return a json result from the content" do
      @response.content_type = "application/json"
      Restfulie::MediaType.should_receive(:type_for).and_return(Shipment)
      Shipment.should_receive(:from_json).with(@response.body).and_return(@result)
      @instance.parse_get_entity("200").should == @result
    end
    
    it "should return a generic result from the content" do
      @response.content_type = "xhtml"
      Restfulie::MediaType.should_receive(:type_for).and_return(Shipment)
      @instance.should_receive(:generic_parse_get_entity).with("xhtml", Shipment).and_return(@result)
      @instance.parse_get_entity("200").should == @result
    end
    
    it "should return the response if its not 200" do
      @instance.parse_get_entity("500").should == @response
    end
    
  end
  
  context "posting" do
    
    it "should treat a 200 post as an enhanced 200 get response entity" do
      response = Object.new
      content = Object.new
      response.should_receive(:code).and_return("200")
      instance = Restfulie::Client::Response.new(NotFollow, response)
      entity = Object.new
      instance.should_receive(:parse_get_entity).with("200").and_return(entity)
      expected_result = Object.new
      instance.should_receive(:enhance).with(entity).and_return(expected_result)
      result = instance.parse_post :nothing
      result.should == expected_result
    end

    it "should not follow moved permanently" do
      response = Object.new
      content = Object.new
      response.should_receive(:code).and_return("301")
      result = Restfulie::Client::Response.new(NotFollow, response).parse_post :nothing
      result.is_a?(Restfulie::Client::WebResponse).should be_true
      result.web_response.should == response
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
      @req = Object.new
      @httpMethod.should_receive(:new).with("/localhost").and_return(@req)
      
      @request = Restfulie::Client::RequestExecution.new(String, nil)
      @request.should_receive(:add_basic_request_headers).with(@req, "delete")

      response = Object.new

      http = Object.new
      http.should_receive(:request).with(@req).and_return(response)

      responder = Object.new
      Restfulie::Client::Response.should_receive(:new).with(String, response).and_return(responder)
      responder.should_receive(:parse).with(@httpMethod, nil, "application/xml")
      Net::HTTP.should_receive(:new).with("localhost", 80).and_return(http)
    end
    
    it "should execute the request" do
      @request.at("http://localhost/localhost").do(@httpMethod, "delete", nil)
    end
    
    it "should post data if it is a post" do
      @req.should_receive(:body=).with("content")
      @req.should_receive(:get_fields).with("Content-type").and_return("txt")
      @request.at("http://localhost/localhost").do(@httpMethod, "delete", "content")
    end
    
    it "should use the default post content type if none is provided" do
      @req.should_receive(:body=).with("content")
      @req.should_receive(:get_fields).with("Content-type").and_return(nil)
      @req.should_receive(:add_field).with("Content-type", "application/xml")
      @request.at("http://localhost/localhost").do(@httpMethod, "delete", "content")
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
      response.should_receive(:parse_get_response).and_return(result)
      Restfulie::Client::Response.should_receive(:new).with(String, res).and_return(response)
      ex = Restfulie::Client::RequestExecution.new(String, nil)
      ex.should_receive(:add_basic_request_headers)
      ex.at('http://www.caelumobjects.com/product').accepts('vnd/product+xml').get.should == result
    end
    
  end

  context "when de-serializing straight from a web request" do
    
    def mock_response(options = {})
      res = Object.new
      options.each do |key, value|
        res.should_receive(key).and_return(value)
      end
      res
    end

    def mock_request_for(type, body, etag = '"ETAGVALUE"')
      res = mock_response(:code => "200", :content_type => type, :body => body)
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
      mock_request_for "application/xml", "<client-restfulie_model><status>CANCELLED</status></client-restfulie_model>"
      
      model = ClientRestfulieModel.from_web 'http://localhost:3001/order/15'
      model.status.should == "CANCELLED"
    end
    
    it "should add the response" do
      mock_request_for "application/xml", "<client-restfulie_model><status>CANCELLED</status></client-restfulie_model>"
  
      model = ClientRestfulieModel.from_web 'http://localhost:3001/order/15'
      model.web_response.should == @response
    end
    
    it "should deserialize correctly if its a json" do
      mock_request_for "application/json", "{client_restfulie_model: { status : 'CANCELLED' }}"
  
      model = ClientRestfulieModel.from_web 'http://localhost:3001/order/15'
      model.status.should == "CANCELLED"
  
    end
  end
  
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
  
  context "when adding headers" do
    
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

end