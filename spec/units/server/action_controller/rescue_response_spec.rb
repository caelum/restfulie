require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Restfulie::Server::Rescue do
  
  it "registers unsupported media type" do
    Restfulie::Server::Rescue.custom_responses['Restfulie::Server::HTTP::UnsupportedMediaTypeError'].should == :unsupported_media_type
  end
  
  it "registers bad request" do
    Restfulie::Server::Rescue.custom_responses['Restfulie::Server::HTTP::BadRequest'].should == :bad_request
  end
  
end
