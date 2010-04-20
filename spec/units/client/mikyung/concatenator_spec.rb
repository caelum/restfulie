require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::Mikyung::Concatenator do

  it "should use the content if there are no extra args" do
    Restfulie::Client::Mikyung::Concatenator.new("alive").content.should == "alive"
  end
  
  it "should concatenate at the end if there is some extra content" do
    Restfulie::Client::Mikyung::Concatenator.new("alive", Restfulie::Client::Mikyung::Concatenator.new("should")).content.should == "alive should"
  end
  
end

