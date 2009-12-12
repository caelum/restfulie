require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class ClientOrder < ActiveRecord::Base
  attr_accessor :buyer
  uses_restfulie
end

context Restfulie::Client::RequestExecution do

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
    
    it "return the post response if got a 200" do
      @mock_response.should_receive(:code).and_return("200")
      define_http_expectation(@req, @mock_response)

      res = Restfulie::Client::RequestExecution.new(ClientOrder).at('http://www.caelumobjects.com/product').create @content
      res.should eql(@mock_response)
    end
    
    it "should not follow moved permanently" do
      
      @mock_response.should_receive(:code).and_return("301")
      define_http_expectation(@req, @mock_response)

      res = Restfulie::Client::RequestExecution.new(ClientOrder).at('http://www.caelumobjects.com/product').create @content
      res.should eql(@mock_response)
    end
    
    it "should follow 301 if instructed to do so" do
    	ClientOrder.follows.moved_permanently
      
      @mock_response.should_receive(:code).and_return("301")
      @mock_response.should_receive(:[]).with("Location").and_return("http://www.caelumobjects.com/product/new_location")
      define_http_expectation(@req, @mock_response)

      @second_req = expect_request('/product/new_location')
      @second_response = mock Net::HTTPResponse
      @second_response.should_receive(:code).and_return("200")
      define_http_expectation(@second_req, @second_response)

      res = Restfulie::Client::RequestExecution.new(ClientOrder).at('http://www.caelumobjects.com/product').create @content
      res.should eql(@second_response)
    end
    
    def define_http_expectation(req, mock_response)
      http = mock Net::HTTP
      Net::HTTP.should_receive(:new).with('www.caelumobjects.com', 80).and_return(http)
      http.should_receive(:request).with(req).and_return(mock_response)
      http
    end

  end

end