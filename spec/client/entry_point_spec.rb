require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class ClientRestfulieModel < ActiveRecord::Base
  attr_accessor :content
  uses_restfulie
end

class ClientOrder < ActiveRecord::Base
  attr_accessor :buyer
  uses_restfulie
end

context "accepts client unmarshalling" do

  context "while using a creation entry point" do
  	
  	before do
    	ClientRestfulieModel.entry_point_for.create.at 'http://www.caelumobjects.com/product'
      @model = ClientRestfulieModel.new
      @req = expect_request('/product')
      @mock_response = mock Net::HTTPResponse
    end
    
    def expect_request(uri)
      req = mock Net::HTTP::Post
      Net::HTTP::Post.should_receive(:new).with(uri).and_return(req)
      req.should_receive(:body=).with(@model.to_xml)
      req.should_receive(:add_field).with("Accept", "application/xml")
      req.should_receive(:add_field).with("Content-type", "application/xml")
      req
    end
    
    it "allows to use a POST entry point" do
      @mock_response.should_receive(:code).and_return("200")
      define_http_expectation(@req, @mock_response)

      res = ClientRestfulieModel.remote_create @model.to_xml
      res.should eql(@mock_response)
    end
    
    it "should not follow moved permanently" do
      
      @mock_response.should_receive(:code).and_return("301")
      define_http_expectation(@req, @mock_response)

      res = ClientRestfulieModel.remote_create @model.to_xml
      res.should eql(@mock_response)
    end
    it "should follow 301 if instructed to do so" do
    	ClientRestfulieModel.follows.moved_permanently
      
      @mock_response.should_receive(:code).and_return("301")
      @mock_response.should_receive(:[]).with("Location").and_return("http://www.caelumobjects.com/product/new_location")
      define_http_expectation(@req, @mock_response)

      @second_req = expect_request('/product/new_location')
      @second_response = mock Net::HTTPResponse
      @second_response.should_receive(:code).and_return("200")
      define_http_expectation(@second_req, @second_response)

      res = ClientRestfulieModel.remote_create @model.to_xml
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