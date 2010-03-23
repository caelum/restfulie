require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.join(File.dirname(__FILE__),'..', '..', 'data','data_helper')

module Restfulie::Client::HTTP::Marshal::Response::Test 
  class CustomUnmarshal
    def self.unmarshal(response)
      new
    end
  end
end

context Restfulie::Client::HTTP::Marshal::Response do
  
  it 'shouldnt unmarshal undefined content-type' do
    response = Restfulie::Client::HTTP::Marshal::Response.new(:get, '\foo', 200, 'body', {})
    raw = response.unmarshal
    raw.class.should == Restfulie::Client::HTTP::Marshal::Response::Raw
    raw.response.should == response
    raw.response.body.should == 'body'
  end

  it 'shouldnt unmarshal unregistered content-type' do
    response = Restfulie::Client::HTTP::Marshal::Response.new(:get, '\foo', 200, 'body', {'content-type'=> 'img/my_custom_image_type'})
    raw = response.unmarshal
    raw.class.should == Restfulie::Client::HTTP::Marshal::Response::Raw
    raw.response.should == response
    raw.response.body.should == 'body'
  end

  it 'should unmarshal with custom unmarshaller' do
    Restfulie::Client::HTTP::Marshal::Response.register("custom_type", Restfulie::Client::HTTP::Marshal::Response::Test::CustomUnmarshal)
    response = Restfulie::Client::HTTP::Marshal::Response.new(:get, '\foo', 200, 'body', {'content-type'=> 'custom_type'})
    custom_unmarshalled = response.unmarshal
    custom_unmarshalled.class.should == Restfulie::Client::HTTP::Marshal::Response::Test::CustomUnmarshal
    custom_unmarshalled.response.should == response
    custom_unmarshalled.response.body.should == 'body'
  end

end

context Restfulie::Client::HTTP::Marshal::RequestBuilder do

  it 'shouldnt unmarshal if forcing raw' do
    Restfulie::Client::HTTP::Marshal::Response.register('application/atom+xml', Restfulie::Client::HTTP::Marshal::Response::Test::CustomUnmarshal)
    raw = Restfulie::Client::EntryPoint.at('http://localhost:4567/songs').accepts('application/atom+xml').raw.get!
    raw.response.code.should == 200
    raw.class.should == Restfulie::Client::HTTP::Marshal::Response::Raw
    raw.response.body.should == response_data( 'atoms', 'songs' )
  end 

end
