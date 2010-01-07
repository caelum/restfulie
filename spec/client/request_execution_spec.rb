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
  
  it "should include response access methods when returning the result" do
    response = Object.new
    content = Object.new
    response.should_receive(:code).and_return("200")
    result = Restfulie::Client::Response.new(NotFollow, response).parse_post
    result.is_a?(Restfulie::Client::WebResponse).should be_true
    result.web_response.should eql(response)
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

  it "should not follow moved permanently" do
    response = Object.new
    content = Object.new
    response.should_receive(:code).and_return("301")
    result = Restfulie::Client::Response.new(NotFollow, response).parse_post
    result.is_a?(Restfulie::Client::WebResponse).should be_true
    result.web_response.should eql(response)
  end
  
  it "should follow 301 if instructed to do so" do
    expected = Object.new
    location = "http://newuri"
    content = Object.new
    response = {"Location" => location}
    response.should_receive(:body).and_return(content)
    response.should_receive(:code).and_return("301")
    Follow.should_receive(:remote_post_to).with(location, content).and_return(expected)
    result = Restfulie::Client::Response.new(Follow, response).parse_post
    result.web_response.should eql(response)
    result.should eql(expected)
  end
  
end

context Restfulie::Client::RequestExecution do

  def define_http_expectation(req, mock_response)
    http = mock Net::HTTP
    Net::HTTP.should_receive(:new).with('www.caelumobjects.com', 80).and_return(http)
    http.should_receive(:request).with(req).and_return(mock_response)
    http
  end

  context "when creating" do
    it "should post" do
      content = "content to post"
      execution = Restfulie::Client::RequestExecution.new(nil)
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
      req.should_receive(:add_field).with("Accept", "application/xml")
      req.should_receive(:add_field).with("Content-type", "application/xml")
      req
    end
    
    it "invoke parse post content, create the post request, and return its content" do
      define_http_expectation(@req, @mock_response)

      parsed_result = Object.new
      result = mock Restfulie::Client::Response
      result.should_receive(:parse_post).and_return(parsed_result)
      Restfulie::Client::Response.should_receive(:new).and_return(result)
      
      res = Restfulie::Client::RequestExecution.new(ClientOrder).at('http://www.caelumobjects.com/product').create @content
      res.should eql(parsed_result)
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
      req.should_receive(:add_field).with("Accept", "vnd/product+xml")
      res = Hashi::CustomHash.new
      res.code = "200"
      define_http_expectation(req, res)
      ex = Restfulie::Client::RequestExecution.new(nil)
      ex.should_receive(:parse_get_ok_response).with(res, "200").and_return(result)
      ex.at('http://www.caelumobjects.com/product').accepts('vnd/product+xml').get.should eql(result)
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
      res.should_receive(:[]).with('Etag').at_least(1).and_return(etag)
      res.should_receive(:[]).with('Last-Modified').at_least(1).and_return(etag)
      @response = res
      req = mock Net::HTTPRequest
      req.should_receive(:add_field).with('Accept', 'application/xml')
      Net::HTTP::Get.should_receive(:new).with('/order/15').and_return(req)
      http = Object.new
      Net::HTTP.should_receive(:new).with('localhost',3001).and_return(http)
      http.should_receive(:request).with(req).and_return(res)
    end
    
    it "should deserialize correctly if its an xml" do
      mock_request_for "application/xml", "<client-restfulie_model><status>CANCELLED</status></client-restfulie_model>"
      
      model = ClientRestfulieModel.from_web 'http://localhost:3001/order/15'
      model.status.should eql("CANCELLED")
    end
    
    it "should add the response" do
      mock_request_for "application/xml", "<client-restfulie_model><status>CANCELLED</status></client-restfulie_model>"
  
      model = ClientRestfulieModel.from_web 'http://localhost:3001/order/15'
      model.web_response.should eql(@response)
    end
    
    it "should save etag value" do
      mock_request_for "application/xml", "<client-restfulie_model><status>CANCELLED</status></client-restfulie_model>", '"custom-etag"'
  
      model = ClientRestfulieModel.from_web 'http://localhost:3001/order/15'
      model.etag.should be_eql('"custom-etag"')
  
    end
    
    it "should deserialize correctly if its a json" do
      mock_request_for "application/json", "{client_restfulie_model: { status : 'CANCELLED' }}"
  
      model = ClientRestfulieModel.from_web 'http://localhost:3001/order/15'
      model.status.should eql("CANCELLED")
  
    end
  end

end