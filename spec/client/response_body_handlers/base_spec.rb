require File.join(File.dirname(__FILE__),'..','..','spec_helper')


context Restfulie::Client::ResponseBodyHandler::Base do
  
  it 'should unmarshal raw response for undefined content-type' do
    response = Restfulie::Client::ResponseBodyHandler::Base.new(:get, '\foo', 200, 'body', {})
    raw = response.unmarshal
    raw.class.should == Restfulie::Client::ResponseBodyHandler::Base::Raw
    raw.response.should == response
    raw.response.body.should == 'body'
  end

  it 'should unmarshal raw response for unregistered content-type' do
    response = Restfulie::Client::ResponseBodyHandler::Base.new(:get, '\foo', 200, 'body', {'content-type'=> 'xpto'})
    raw = response.unmarshal
    raw.class.should == Restfulie::Client::ResponseBodyHandler::Base::Raw
    raw.response.should == response
    raw.response.body.should == 'body'
  end

end
