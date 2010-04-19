require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Hash do
  before do
    @hash = {"name" => "Guilherme Silveira", "link" => ["rel" => "start"]}
  end
  context "when requesting its links" do
    it "should return all links if there is more than one" do
      @hash["link"] << ["rel" => "end"]
      @hash.links.size.should == 2
    end
    it "should return the only link within an array" do
      @hash.links.size.should == 1
    end
    it "should return empty array if there are no links" do
      @hash.delete("link")
      @hash.links.should == []
    end
    it "should return the selected link if one is requested" do
      @hash.links("start").should be_kind_of(Restfulie::Client::Link)
    end
    it "should return nil if no link is available" do
      @hash.links("end").should be_nil
    end
  end
  context "when retrieving a value" do
    it "should return its value when invoking a method which key is contained" do
      @hash.name.should == "Guilherme Silveira"
    end
    it "should return true when respond_to? a key name" do
      @hash.should respond_to(:name)
      @hash.should respond_to("name")
    end
  end
end

context Restfulie::Common::Representation::XmlD do
  
  context "when unmarshalling" do
    it "should unmarshall an entry" do
      result = Restfulie::Common::Representation::XmlD.new.unmarshal('<root><entry></entry></root>')
      result.should respond_to "entry"
      result.should be_kind_of(Hash)
    end
  end
  
end