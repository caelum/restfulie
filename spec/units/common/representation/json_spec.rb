require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Common::Representation::XmlD do
  
  context "when unmarshalling" do

    it "should unmarshall nothing if there is no value" do
      hash = {}
      result = Restfulie::Common::Representation::Json.new.unmarshal(hash.to_json)
      result.should == hash
    end
    
    it "should unmarshall an entry, including the root object" do
      hash = {"company" => {"name"=>"value"}}
      result = Restfulie::Common::Representation::Json.new.unmarshal(hash.to_json)
      result.should == hash
    end
  end
  context "when marshalling" do

    it "should return itself if its a string" do
      result = Restfulie::Common::Representation::Json.new.marshal("content", "")
      result.should == "content"
    end
    it "should serialize if its anything else" do
      hash = {"name" => "value"}
      result = Restfulie::Common::Representation::Json.new.marshal(hash, "")
      result.should == hash.to_json
    end
  end
  
end