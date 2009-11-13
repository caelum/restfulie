require 'net/http'
require 'uri'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class RestfulieModel < ActiveRecord::Base
  attr_accessor :content
end

class Order < ActiveRecord::Base
  attr_accessor :buyer
end

class MockedController
  def url_for(x)
    "http://url_for/#{x[:action]}"
  end
end

describe RestfulieModel do

  before do
    subject.status = :unpaid
  end

  describe "when parsed to json" do
    it "should include the method following_states" do
      subject.to_json.should eql("{\"status\":\"unpaid\"}")
    end
  end
  
  def base
    '<?xml version="1.0" encoding="UTF-8"?><restfulie-model>'
  end
  def link(href, rel)
    '<atom:link xmlns:atom="http://www.w3.org/2005/Atom"' \
     + ' href="' + href + '"'\
     + ' rel="' + rel + '"'\
     + '/>'
  end
  
  describe "when parsed to xml" do
    it "should not add hypermedia if controller is nil" do
        subject.to_xml.gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>unpaid</status></restfulie-model>')
      end
      it "should add allowable actions to models xml if controller is set" do
        my_controller = MockedController.new
        RestfulieModel.transition :latest, {:controller => my_controller, :action => :show}
        RestfulieModel.state :unpaid, :allow => :latest
        
        expected = normalize_xml('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>unpaid</status>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" href="http://url_for/show" rel="latest"/></restfulie-model>')
        got      = normalize_xml(subject.to_xml(:controller => my_controller).gsub("\n", ''))
        
        got.should eql(expected)
      end
      it "should add more than 1 allowable actions to models xml if controller is set" do
        my_controller = MockedController.new
        RestfulieModel.transition :latest, {:controller => my_controller, :action => :show}
        RestfulieModel.state :unpaid, :allow => [:latest, :latest]
        
        expected = normalize_xml(base + '  <status>unpaid</status>  '+link('http://url_for/show','latest')+'  '+link('http://url_for/show','latest')+'</restfulie-model>')
        got      = normalize_xml(subject.to_xml(:controller => my_controller).gsub("\n", ''))
        
        got.should eql(expected)
      end
      it "should add extra transitions if following_transitions are defined" do
        my_controller = MockedController.new
        RestfulieModel.transition :latest, {:controller => my_controller, :action => :show}
        RestfulieModel.state :unpaid, :allow => [:latest]
        def subject.following_transitions
          [:latest]
        end
        
        expected = normalize_xml(base + '  <status>unpaid</status>  '+link('http://url_for/show','latest')+'  '+link('http://url_for/show','latest')+'</restfulie-model>')
        got      = normalize_xml(subject.to_xml(:controller => my_controller).gsub("\n", ''))
        
        got.should eql(expected)
      end
      it "should add and create extra transition through following_transitions" do
        my_controller = MockedController.new
        RestfulieModel.state :unpaid, :allow => []
        def subject.following_transitions
          [[:latest, { :action => :thanks }]]
        end
        
        expected = normalize_xml(base + '  <status>unpaid</status>  '+link('http://url_for/thanks','latest')+'</restfulie-model>')
        got      = normalize_xml(subject.to_xml(:controller => my_controller).gsub("\n", ''))
        
        got.should eql(expected)
      end
      it "should add hypermedia link if controller is set and told to use name based link" do
        my_controller = MockedController.new
        RestfulieModel.transition :latest, {:controller => my_controller, :action => :show}
        RestfulieModel.state :unpaid, :allow => [:latest]
        subject.to_xml(:controller => my_controller, :use_name_based_link => true).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>unpaid</status>  <latest>http://url_for/show</latest></restfulie-model>')
      end
      it "should use rel if there is a rel attribute" do
        my_controller = MockedController.new
        RestfulieModel.transition :latest, {:controller => my_controller, :action => :show, :rel => :show_me_the_latest}
        RestfulieModel.state :unpaid, :allow => [:latest]
        subject.to_xml(:controller => my_controller, :use_name_based_link => true).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>unpaid</status>  <show_me_the_latest>http://url_for/show</show_me_the_latest></restfulie-model>')
      end
      it "should evaluate in runtime if there is a body to the transition" do
      my_controller = MockedController.new
      RestfulieModel.transition :latest do |me|
         {:action => me.content}
      end
      RestfulieModel.state :unpaid, :allow => [:latest]
      subject.content = :show
      subject.to_xml(:controller => my_controller, :use_name_based_link => true).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>unpaid</status>  <latest>http://url_for/show</latest></restfulie-model>')
    end
    it "should add all states if there is more than one with what is allowed" do
        froms = [:received, :cancelled]
        my_controller = MockedController.new
        RestfulieModel.transition :latest, {:controller => my_controller, :action => :show}
        RestfulieModel.state froms, :allow => [:latest]
        froms.each do |from|
          subject.status = from
          
          expected = normalize_xml('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>' + from.to_s + '</status>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" href="http://url_for/show" rel="latest"/></restfulie-model>')
          got      = normalize_xml(subject.to_xml(:controller => my_controller).gsub("\n", ''))
          
          got.should eql(expected)
        end
      end
      it "should use transition name if there is no action" do
        my_controller = MockedController.new
        RestfulieModel.transition :pay
        RestfulieModel.state :unpaid, :allow => [:pay]
        
        expected = normalize_xml('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>unpaid</status>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" href="http://url_for/pay" rel="pay"/></restfulie-model>')
        got      = normalize_xml(subject.to_xml(:controller => my_controller).gsub("\n", ''))
        
        got.should eql(expected)
      end
      it "should not add anything if in an unknown state" do
        my_controller = MockedController.new
        subject.status = :gone
        subject.to_xml(:controller => my_controller).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>gone</status></restfulie-model>')
      end
      it "should not change status if there is no result" do
        my_controller = MockedController.new
        RestfulieModel.transition :pay
        RestfulieModel.state :unpaid, :allow => [:pay]
        subject.pay
        subject.status.should eql(:unpaid)
      end
      it "should use change status to its result when transitioning" do
        my_controller = MockedController.new
        RestfulieModel.transition :pay, {}, :paid
        RestfulieModel.state :unpaid, :allow => [:pay]
        subject.pay
        subject.status.should eql("paid")
      end
  end
  
  describe "when checking permissions" do
    it "should add can_xxx methods allowing one to check whther the transition is valid or not" do
        my_controller = MockedController.new
        RestfulieModel.transition :pay, {}
        RestfulieModel.state :unpaid, :allow => :pay
        RestfulieModel.state :paid
        
        subject.status = :unpaid
        subject.can_pay?.should eql(true)

        subject.status = :paid
        subject.can_pay?.should eql(false)
        
    end
  end
  
  describe "when adding states" do
    it "should ignore namespaces" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><restfulie-model xmlns="http://www.caelum.com.br/restfulie"></restfulie-model>'
      model = RestfulieModel.from_xml xml
      model.should_not eql(nil)
    end
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

  describe "when invoking an state change" do
    it "should send a DELETE request if the state transition name is cancel, destroy or delete" do
      ["cancel", "destroy", "delete"].each do |method_name|
        model = RestfulieModel.from_xml xml_for(method_name)
        req = mock Net::HTTP::Delete
        Net::HTTP::Delete.should_receive(:new).with('/order/1').and_return(req)
        req.should_receive(:set_form_data).with({})

        expected_response = prepare_http_for(req)
        res = model.send(method_name)
        res.should eql(expected_response)
      end
    end
    it "should send a POST request if the state transition name is update" do
        model = RestfulieModel.from_xml xml_for('update')
        req = mock Net::HTTP::Post
        Net::HTTP::Post.should_receive(:new).with('/order/1').and_return(req)
        req.should_receive(:set_form_data).with({})

        expected_response = prepare_http_for(req)
        res = model.send('update')
        res.should eql(expected_response)
    end
    it "should send a GET request if the state transition name is refresh, reload, show or latest" do
      ["refresh", "latest", "reload", "show"].each do |method_name|
        model = RestfulieModel.from_xml xml_for(method_name)
        req = mock Net::HTTP::Get
        Net::HTTP::Get.should_receive(:new).with('/order/1').and_return(req)
        req.should_receive(:set_form_data).with({})
    
        expected_response = prepare_http_for(req)
        expected_response.should_receive(:body).and_return("<restfulie_model></restfulie_model>")
        expected_response.should_receive(:content_type).and_return('application/xml')
        res = model.send(method_name)
        res.class.to_s.should eql('RestfulieModel')
      end
    end
    it "should allow method overriding" do
        model = RestfulieModel.from_xml xml_for('update')
        req = mock Net::HTTP::Delete
        Net::HTTP::Delete.should_receive(:new).with('/order/1').and_return(req)
        req.should_receive(:set_form_data).with({})

        expected_response = prepare_http_for(req)
        res = model.send('update', {:method=>"delete"})
        res.should eql(expected_response)
    end
    it "a GET should return the parsed content" do
        model = RestfulieModel.from_xml xml_for('check_info')
        req = mock Net::HTTP::Get
        Net::HTTP::Get.should_receive(:new).with('/order/1').and_return(req)
        req.should_receive(:set_form_data).with({})

        expected_response = prepare_http_for(req)
        expected_response.should_receive(:body).and_return("<order><buyer>guilherme silveira</buyer></order>")
        expected_response.should_receive(:content_type).and_return('application/xml')
        res = model.send('check_info', {:method => "get"})
        res.class.to_s.should eql('Order')
        res.buyer.should eql('guilherme silveira')
    end
    it "should allow the user to receive the response" do
        model = RestfulieModel.from_xml xml_for('check_info')
        req = mock Net::HTTP::Get
        Net::HTTP::Get.should_receive(:new).with('/order/1').and_return(req)
        req.should_receive(:set_form_data).with({})

        expected_response = prepare_http_for(req)
        expected_result = "my_custom_info"
        my_result = model.send('check_info', {:method => "get"}) do |response|
          response.should eql(expected_response)
          expected_result
        end
        my_result.should eql(expected_result)
    end
  end
  
  def mock_response(options = {})
    res = mock Net::HTTPResponse
    options.keys.each do |x|
      res.should_receive(x).and_return(options[x])
    end
    res
  end
  
  describe "when de-serializing straight from a web request" do
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
