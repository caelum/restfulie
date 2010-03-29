require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ActionController::Rescue do
  
  it "registers unsupported media type" do
    ActionController::Rescue::DEFAULT_RESCUE_RESPONSES['Restfulie::Server::HTTP::UnsupportedMediaType'].should == :unsupported_media_type
  end
  
end
