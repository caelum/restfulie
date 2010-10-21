require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::HTTP do

  context 'RequestHistory' do
  
    before(:all) do
      @host = "http://localhost:4567"
      @builder = Restfulie.at(@host).history
    end
  
    it "should remember last requests" do
      @builder.at('/test').accepts('application/atom+xml').with('Accept-Language' => 'en').get.should respond_with_status(200)
      @builder.at('/test').accepts('text/html').with('Accept-Language' => 'pt-BR').head.should respond_with_status(200)
      @builder.at('/test').as('application/xml').with('Accept-Language' => 'en').post!('test').should respond_with_status(201)
      @builder.at('/test/500').accepts('application/xml').with('Accept-Language' => 'en').get.should respond_with_status(500)
  
      @builder.history(0).request.should respond_with_status(200)
      @builder.path.should == '/test'
      @builder.host.to_s.should == @host + "/test"
      @builder.headers['Accept'].should == 'application/atom+xml'
      @builder.headers['Accept-Language'].should == 'en'
  
      @builder.history(1).request.should respond_with_status(200)
      @builder.path.should == '/test'
      @builder.host.to_s.should == @host + "/test"
      @builder.headers['Accept'].should == 'text/html'
      @builder.headers['Accept-Language'].should == 'pt-BR'
  
      @builder.history(2).request.should respond_with_status(201)
      @builder.path.should == '/test'
      @builder.host.to_s.should == @host + "/test"
      @builder.headers['Accept'].should == 'application/xml'
      @builder.headers['Accept-Language'].should == 'en'
      @builder.headers['Content-Type'].should == 'application/xml'
  
      @builder.history(3).request.should respond_with_status(500)
      @builder.path.should == '/test/500'
      @builder.host.to_s.should == @host + "/test/500"
      @builder.headers['Accept'].should == 'application/xml'
      @builder.headers['Accept-Language'].should == 'en'
  
      lambda { @builder.history(10).request }.should raise_error RuntimeError
    end 
  
  end
    
end

