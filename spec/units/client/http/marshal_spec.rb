require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::HTTP::Marshal::Response do
  
  it 'shouldnt unmarshal undefined content-type' do
    response = Restfulie::Client::HTTP::Marshal::Response.new(:get, '\foo', 200, 'body', {})
    raw = response.unmarshal(false)
    raw.class.should == Restfulie::Client::HTTP::Marshal::Response::Raw
    raw.response.should == response
    raw.response.body.should == 'body'
  end

  it 'shouldnt unmarshal unregistered content-type' do
    response = Restfulie::Client::HTTP::Marshal::Response.new(:get, '\foo', 200, 'body', {'content-type'=> 'img/my_custom_image_type'})
    raw = response.unmarshal(false)
    raw.class.should == Restfulie::Client::HTTP::Marshal::Response::Raw
    raw.response.should == response
    raw.response.body.should == 'body'
  end
  
  class CustomUnmarshal
  end

  it 'shouldnt unmarshal if forcing raw' do
    Restfulie::Client::HTTP::Marshal::Response.register("custom_type", CustomUnmarshal)
    response = Restfulie::Client::HTTP::Marshal::Response.new(:get, '\foo', 200, 'body', {'content-type'=> 'custom_type'})
    raw = response.unmarshal(true)
    raw.class.should == Restfulie::Client::HTTP::Marshal::Response::Raw
    raw.response.should == response
    raw.response.body.should == 'body'
  end

end
