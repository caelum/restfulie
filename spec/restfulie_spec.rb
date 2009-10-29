require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class RestfulieModel < ActiveRecord::Base
  def following_states
    [{:rel => "next_state"}]
  end
end

class MockedController
  def url_for(x)
    "http://url_for/#{x['ref']}"
  end
end

describe RestfulieModel do
  context "when parsed to json" do
    it "should include the method following_states" do
      subject.to_json.should eql("{\"following_states\":[{\"rel\":\"next_state\"}]}")
    end
  end

  context "when parsed to xml" do
    it "should not add hypermedia if controller is nil" do
      subject.to_xml.gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model></restfulie-model>')
    end
    it "should add hypermedia atom link if controller is set" do
      my_controller = MockedController.new
      subject.to_xml(:controller => my_controller).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model></restfulie-model>')
    end
  end
end
