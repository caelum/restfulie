require 'net/http'
require 'uri'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class RestfulieModel < ActiveRecord::Base
  attr_accessor :status
  def following_states
    {:rel => "next_state", :action => "action_name"}
  end
end

class MockedController
  def url_for(x)
    "http://url_for/#{x[:action]}"
  end
end

describe RestfulieModel do
    
  context "when parsed to json" do
    it "should include the method following_states" do
      subject.to_json.should eql("{\"following_states\":{\"rel\":\"next_state\",\"action\":\"action_name\"}}")
    end
  end
  
  context "when parsed to xml" do
    it "should not add hypermedia if controller is nil" do
      subject.to_xml.gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model></restfulie-model>')
    end
    it "should add hypermedia atom link if controller is set" do
      my_controller = MockedController.new
      subject.to_xml(:controller => my_controller).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="next_state" href="http://url_for/action_name"/></restfulie-model>')
    end
    it "should add hypermedia link if controller is set and told to use name based link" do
      my_controller = MockedController.new
      subject.to_xml(:controller => my_controller, :use_name_based_link => true).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <next_state>http://url_for/action_name</next_state></restfulie-model>')
    end
    it "should use action name if there is no rel attribute" do
      def subject.following_states
        [{:action => "next_action"}]
      end
      my_controller = MockedController.new
      subject.to_xml(:controller => my_controller, :use_name_based_link => true).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <next_action>http://url_for/next_action</next_action></restfulie-model>')
    end
  end
  
  context "when adding states" do
    it "should be able to answer to the method rel name" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="pay" href="http://url_for/action_name"/><atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="next_state" href="http://url_for/action_name"/></restfulie-model>'
      model = RestfulieModel.from_xml xml
      model.respond_to?('pay').should eql(true)
    end
    it "should be able to answer to just one state change" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="cancel" href="http://url_for/action_name"/></restfulie-model>'
      model = RestfulieModel.from_xml xml
      model.respond_to?('cancel').should eql(true)
    end
  end

  def xml_for(method_name)
    '<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="' + method_name + '" href="http://localhost/order/1"/></restfulie-model>'
  end
  def prepare_http_for(request)
    request.should_receive(:add_field).with("Accept", "text/xml")
    response = mock Net::HTTPResponse
    http = mock Net::HTTP
    Net::HTTP.should_receive(:new).with('localhost', 80).and_return(http)
    http.should_receive(:request).with(request).and_return(response)
    response
  end

  context "when invoking an state change" do
    it "should send a DELETE request if the state transition name is cancel, destroy or delete" do
      ["cancel", "destroy", "delete"].each do |method_name|
        model = RestfulieModel.from_xml xml_for(method_name)
        req = mock Net::HTTP::Delete
        Net::HTTP::Delete.should_receive(:new).with('/order/1').and_return(req)

        expected_response = prepare_http_for(req)
        res = model.send(method_name)
        res.should eql(expected_response)
      end
    end
    it "should send a POST request if the state transition name is update" do
        model = RestfulieModel.from_xml xml_for('update')
        req = mock Net::HTTP::Post
        Net::HTTP::Post.should_receive(:new).with('/order/1').and_return(req)

        expected_response = prepare_http_for(req)
        res = model.send('update')
        res.should eql(expected_response)
    end
    it "should send a GET request if the state transition name is refresh, reload or show" do
      ["refresh", "reload", "show"].each do |method_name|
        model = RestfulieModel.from_xml xml_for(method_name)
        req = mock Net::HTTP::Get
        Net::HTTP::Get.should_receive(:new).with('/order/1').and_return(req)

        expected_response = prepare_http_for(req)
        res = model.send(method_name)
        res.should eql(expected_response)
      end
    end
    it "should allow method overriding" do
        model = RestfulieModel.from_xml xml_for('update')
        req = mock Net::HTTP::Delete
        Net::HTTP::Delete.should_receive(:new).with('/order/1').and_return(req)

        expected_response = prepare_http_for(req)
        res = model.send('update', {:method=>"delete"})
        res.should eql(expected_response)
    end
  end
  
  def mock_response(options = {})
    res = mock Net::HTTPResponse
    options.keys.each do |x|
      res.should_receive(x).and_return(options[x])
    end
    res
  end
  
  context "when de-serializing straight from a web request" do
    def mock_request_for(type, body)
      req = mock Net::HTTP::Get
      Net::HTTP::Get.should_receive(:new).with('/order/15').and_return(req)
      http = mock Net::HTTP
      Net::HTTP.should_receive(:new).with('localhost', 3001).and_return(http)
      res = mock_response(:code => "200", :content_type => type, :body => body)
      http.should_receive(:request).with(req).and_return(res)
    end
    it "should deserialize correctly if its an xml" do
      mock_request_for "application/xml", "<restfulie_model><status>CANCELLED</status></restfulie_model>"

      model = RestfulieModel.from_web 'http://localhost:3001/order/15'
      model.status.should eql("CANCELLED")

    end
    it "should deserialize correctly if its a json" do
      mock_request_for "application/json", "{ status : 'CANCELLED' }"

      model = RestfulieModel.from_web 'http://localhost:3001/order/15'
      model.status.should eql("CANCELLED")

    end
  end
  
end
