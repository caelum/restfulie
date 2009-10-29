require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class RestfulieModel < ActiveRecord::Base
  def following_states
    [{:rel => "next_state", :action => "action_name"}]
  end
end

class MockedController
  def url_for(x)
    puts "asking url for #{x}"
    "http://url_for/#{x[:action]}"
  end
end

describe RestfulieModel do
  
  context "when parsed to json" do
    it "should include the method following_states" do
      subject.to_json.should eql("{\"following_states\":[{\"rel\":\"next_state\",\"action\":\"action_name\"}]}")
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
      xml = '<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="next_state" href="http://url_for/action_name"/><atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="next_state" href="http://url_for/action_name"/></restfulie-model>'
      model = RestfulieModel.from_xml xml
      model.respond_to?('next_state').should eql(true)
    end
    it "should be able to answer to just one state change" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="next_state" href="http://url_for/action_name"/></restfulie-model>'
      model = RestfulieModel.from_xml xml
      model.respond_to?('next_state').should eql(true)
    end
  end
  
end
