require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.join(File.dirname(__FILE__),'..', '..', 'data','data_helper')

context Restfulie::Client::HTTP::RequestMarshaller do

  it 'shouldnt unmarshal if forcing raw' do
    marshaller = Restfulie::Client::HTTP::RequestMarshallerExecutor.new('http://localhost:4567')
    raw_response = marshaller.at('/songs').accepts('application/atom+xml').raw.get!
    raw_response.code.should == 200
    raw_response.class.should == Restfulie::Client::HTTP::Response
    raw_response.body.should == response_data( 'atoms', 'songs' )
  end 

end
