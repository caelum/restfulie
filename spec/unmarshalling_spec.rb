require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Restfulie do
  
  context "when creating an object from a hash" do
    it "it should allow direct attribute access" do
      hash = {"name" => "guilherme silveira"}
      Restfulie.hash_to_object(hash).name.should == ("guilherme silveira")
    end
    it "it should allow direct attribute attribution" do
      hash = {"name" => "guilherme silveira"}
      Restfulie.hash_to_object(hash).name = "donizetti"
      Restfulie.hash_to_object(hash).name.should == ("donizetti")
    end
    it "it should allow access to child element" do
      hash = {"player" => {"name" => "guilherme silveira"}}
      Restfulie.hash_to_object(hash).player.name.should == ("guilherme silveira")
    end
    it "it should allow access attribution to child element" do
      hash = {"player" => {"name" => "guilherme silveira"}}
      Restfulie.hash_to_object(hash).player.name = "donizetti"
      Restfulie.hash_to_object(hash).player.name.should == ("donizetti")
    end
    it "it should allow access to an array element" do
      hash = {"player" => [{"name" => "guilherme silveira"}, {"name" => "caue guerra"}]}
      Restfulie.hash_to_object(hash).player[1].name.should == ("caue guerra")
    end
    it "it should allow access attribution to an array element" do
      hash = {"player" => [{"name" => "guilherme silveira"}, {"name" => "caue guerra"}]}
      Restfulie.hash_to_object(hash).player[1].name = "donizetti"
      Restfulie.hash_to_object(hash).player[1].name.should == ("donizetti")
    end
  end
  
end