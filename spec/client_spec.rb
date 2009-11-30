require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class ClientRestfulieModel < ActiveRecord::Base
  attr_accessor :content
  uses_restfulie
end

class ClientOrder < ActiveRecord::Base
  attr_accessor :buyer
  uses_restfulie
end

context "client unmarshalling" do

  context "when adding states" do
  
    it "should ignore namespaces" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><client-restfulie-model xmlns="http://www.caelum.com.br/restfulie"></client-restfulie-model>'
      model = ClientRestfulieModel.from_xml xml
      model.should_not eql(nil)
    end
  
    it "should be able to answer to the method rel name" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><client-restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="pay" href="http://url_for/action_name"/><atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="next_state" href="http://url_for/action_name"/></client-restfulie-model>'
      model = ClientRestfulieModel.from_xml xml
      puts model._possible_states
      model.respond_to?('pay').should eql(true)
    end
  
    it "should be able to answer to just one state change" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><client-restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="cancel" href="http://url_for/action_name"/></client-restfulie-model>'
      model = ClientRestfulieModel.from_xml xml
      model.respond_to?('cancel').should eql(true)
    end
  
  end
  
  
  context "when invoking an state change" do
    
    it "should send a DELETE request if the state transition name is cancel, destroy or delete" do
      ["cancel", "destroy", "delete"].each do |method_name|
        model = ClientRestfulieModel.from_xml xml_for(method_name)
        req = mock Net::HTTP::Delete
        Net::HTTP::Delete.should_receive(:new).with('/order/1').and_return(req)
  
        expected_response = prepare_http_for(req)
        res = model.send(method_name)
        res.should eql(expected_response)
      end
    end
    
    it "should send a POST request if the state transition name is update" do
        model = ClientRestfulieModel.from_xml xml_for('update')
        req = mock Net::HTTP::Post
        Net::HTTP::Post.should_receive(:new).with('/order/1').and_return(req)
  
        expected_response = prepare_http_for(req)
        res = model.send('update')
        res.should eql(expected_response)
    end
    
    it "should send a GET request if the state transition name is refresh, reload, show or latest" do
      ["refresh", "latest", "reload", "show"].each do |method_name|
        model = ClientRestfulieModel.from_xml xml_for(method_name)
        req = mock Net::HTTP::Get
        Net::HTTP::Get.should_receive(:new).with('/order/1').and_return(req)

        expected_response = prepare_http_for(req)
        expected_response.should_receive(:body).exactly(2).times.and_return("<client-restfulie_model></client-restfulie_model>")
        expected_response.should_receive(:content_type).and_return('application/xml')
        res = model.send(method_name)
        res.class.to_s.should eql('ClientRestfulieModel')
      end
    end
    
    it "should allow method overriding for methods given as symbols" do
      model = ClientRestfulieModel.from_xml xml_for('execute')

      req = mock Net::HTTP::Delete
      Net::HTTP::Delete.should_receive(:new).with('/order/1').and_return(req)

      expected_response = prepare_http_for(req)
      res = model.send :execute, :method => 'delete'
      res.should eql(expected_response)
    end

    it "should allow method overriding for methods given as strings" do
      model = ClientRestfulieModel.from_xml xml_for('execute')

      req = mock Net::HTTP::Delete
      Net::HTTP::Delete.should_receive(:new).with('/order/1').and_return(req)

      expected_response = prepare_http_for(req)
      res = model.send('execute', {:method=> 'delete'})
      res.should eql(expected_response)
    end
    
    it "should GET and return its content" do
        model = ClientRestfulieModel.from_xml xml_for('check_info')
        req = mock Net::HTTP::Get
        Net::HTTP::Get.should_receive(:new).with('/order/1').and_return(req)
  
        expected_response = prepare_http_for(req)
        expected_response.should_receive(:body).exactly(2).times.and_return("<client-order><buyer>guilherme silveira</buyer></client-order>")
        expected_response.should_receive(:content_type).and_return('application/xml')
        res = model.send('check_info', {:method => "get"})
        res.class.to_s.should eql('ClientOrder')
        res.buyer.should eql('guilherme silveira')
    end
    
    it "should allow the user to receive the response" do
        model = ClientRestfulieModel.from_xml xml_for('check_info')
        req = mock Net::HTTP::Get
        Net::HTTP::Get.should_receive(:new).with('/order/1').and_return(req)
  
        expected_response = prepare_http_for(req)
        expected_result = "my_custom_info"
        my_result = model.send('check_info', {:method => "get"}) do |response|
          response.should eql(expected_response)
          expected_result
        end
        my_result.should eql(expected_result)
    end
    
  end

  
  def xml_for(method_name)
    '<?xml version="1.0" encoding="UTF-8"?><client-restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="' + method_name + '" href="http://localhost/order/1"/></client-restfulie-model>'
  end

  
  def prepare_http_for(request)
    request.should_receive(:add_field).with("Accept", "application/xml")
    response = mock Net::HTTPResponse
    http = mock Net::HTTP
    Net::HTTP.should_receive(:new).with('localhost', 80).and_return(http)
    http.should_receive(:request).with(request).and_return(response)
    response
  end

  
  context "when de-serializing straight from a web request" do
    
    def mock_request_for(type, body)
      res = mock_response(:code => "200", :content_type => type, :body => body)
      Net::HTTP.should_receive(:get_response).with(URI.parse('http://localhost:3001/order/15')).and_return(res)
    end
    
    it "should deserialize correctly if its an xml" do
      mock_request_for "application/xml", "<client-restfulie_model><status>CANCELLED</status></client-restfulie_model>"
  
      model = ClientRestfulieModel.from_web 'http://localhost:3001/order/15'
      model.status.should eql("CANCELLED")
  
    end
    
    it "should deserialize correctly if its a json" do
      mock_request_for "application/json", "{ status : 'CANCELLED' }"
  
      model = ClientRestfulieModel.from_web 'http://localhost:3001/order/15'
      model.status.should eql("CANCELLED")
  
    end
  end

  def mock_response(options = {})
    res = mock Net::HTTPResponse
    options.keys.each do |x|
      res.should_receive(x).and_return(options[x])
    end
    res
  end
  
  context "while using a creation entry point" do
  	
  	before do
    	ClientRestfulieModel.entry_point_for.create.at 'http://www.caelum.com.br/product'
      @model = ClientRestfulieModel.new
      @req = expect_request('/product')
      @mock_response = mock Net::HTTPResponse
    end
    
    def expect_request(uri)
      req = mock Net::HTTP::Post
      Net::HTTP::Post.should_receive(:new).with(uri).and_return(req)
      req.should_receive(:body=).with(@model.to_xml)
      req.should_receive(:add_field).with("Accept", "application/xml")
      req
    end
    
    it "allows to use a POST entry point" do
      
      @mock_response.should_receive(:code).and_return(200)
      define_http_expectation(@req, @mock_response)

      res = ClientRestfulieModel.remote_create @model.to_xml
      res.should eql(@mock_response)
    end
    it "should not follow moved permanently" do
      
      @mock_response.should_receive(:code).and_return(301)
      define_http_expectation(@req, @mock_response)

      res = ClientRestfulieModel.remote_create @model.to_xml
      res.should eql(@mock_response)
    end
    it "should follow 301 if instructed to do so" do
    	ClientRestfulieModel.follows.moved_permanently
      
      @mock_response.should_receive(:code).and_return(301)
      @mock_response.should_receive(:[]).with("Location").and_return("http://www.caelum.com.br/product/new_location")
      define_http_expectation(@req, @mock_response)

      @second_req = expect_request('/product/new_location')
      @second_response = mock Net::HTTPResponse
      @second_response.should_receive(:code).and_return(200)
      define_http_expectation(@second_req, @second_response)

      res = ClientRestfulieModel.remote_create @model.to_xml
      res.should eql(@second_response)
    end
    
    def define_http_expectation(req, mock_response)
      http = mock Net::HTTP
      Net::HTTP.should_receive(:new).with('www.caelum.com.br', 80).and_return(http)
      http.should_receive(:request).with(req).and_return(mock_response)
      http
    end

    # TESTAR: product = Product.from_web 'http://www.caelum.com.br/product/2' # received a 301, went to the Location

  end

end