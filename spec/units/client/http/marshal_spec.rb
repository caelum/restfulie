require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.join(File.dirname(__FILE__),'..', '..', 'lib','data_helper')

context Restfulie::Client::HTTP::RequestMarshaller do

  it 'shouldnt unmarshal if forcing raw' do
    marshaller = Restfulie::Client::HTTP::RequestMarshallerExecutor.new('http://localhost:4567')
    raw_response = marshaller.at('/songs').accepts('application/atom+xml').raw.get!
    raw_response.code.should == 200
    raw_response.class.should == Restfulie::Client::HTTP::Response
    raw_response.body.should == response_data( 'atoms', 'songs' )
  end 

  it 'should follow 201 responses' do
    marshaller = Restfulie::Client::HTTP::RequestMarshallerExecutor.new('http://localhost:4567')
    raw_response = marshaller.at('/custom/songs').accepts('application/atom+xml').post!("custom")
    raw_response.response.code.should == 200
    raw_response.response.body.should == response_data( 'atoms', 'songs' )
  end 

end
