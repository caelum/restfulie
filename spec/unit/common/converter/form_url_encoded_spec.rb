require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Restfulie::Common::Converter::FormUrlEncoded do
  context "when unmarshalling" do
    
    it "when passing not a hash, returns itself" do
    	Restfulie::Common::Converter::FormUrlEncoded.marshal("some content", "").should == "some content"
    end
    
    it "when passing a hash should concatenate" do
      params = {:user => "guilherme", :password => "my_pass"}
    	Restfulie::Common::Converter::FormUrlEncoded.marshal(params, "").should == "user=guilherme&password=my_pass"
    end
    
  end
end