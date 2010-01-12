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

  context "when adding states" do
  
    it "should ignore namespaces" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><client-restfulie-model xmlns="http://www.caelumobjects.com/restfulie"></client-restfulie-model>'
      model = ClientRestfulieModel.from_xml xml
      model.should_not eql(nil)
    end
  
    it "should be able to answer to the method rel name" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><client-restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="pay" href="http://url_for/action_name"/><atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="next_state" href="http://url_for/action_name"/></client-restfulie-model>'
      model = ClientRestfulieModel.from_xml xml
      model.respond_to?('pay').should eql(true)
    end
  
    it "should be able to answer to just one state change" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><client-restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="cancel" href="http://url_for/action_name"/></client-restfulie-model>'
      model = ClientRestfulieModel.from_xml xml
      model.respond_to?('cancel').should eql(true)
    end
  
  end
  
  context "when invoking an state change" do

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

        final_result = Object.new
        ClientRestfulieModel.should_receive(:from_response).with(prepare_http_for(req), model).and_return(final_result)
        model.send('check_info', {:method => "get"}).should eql(final_result)
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

end