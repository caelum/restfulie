require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Server::HTTP::XmlUnmarshaller do
  
  class Shipment < ActiveRecord::Base
  end
  
  it "complains if there is more than one root element" do
    content = "<shipment></shipment><shipment></shipment>"
    assert_raise Restfulie::Server::HTTP::XmlUnmarshaller.unmarshal(content)
  end
  
  it "complains if there is no root element" do
    content = ""
    assert_raise Restfulie::Server::HTTP::XmlUnmarshaller.unmarshal(content)
  end
  
  it "complains if there is no such type" do
    content = "<weird></weird>"
    assert_raise Restfulie::Server::HTTP::XmlUnmarshaller.unmarshal(content)
  end
  
  it "uses ActiveRecord's hash constructor if its an ActiveRecord" do
    something = mock Shipment
    
    content = "<shipment><id>5</id></shipment>"
    Shipment.should_receive(:new).with(Hash.from_xml(content)["shipment"]).and_return(something)
    Restfulie::Server::HTTP::XmlUnmarshaller.unmarshal(content).should == something
  end
  
end

