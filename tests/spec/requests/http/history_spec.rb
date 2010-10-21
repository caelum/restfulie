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
      @builder.at('/test').as('application/xml').with('Accept-Language' => 'en').delete!.should respond_with_status(200)
      @builder.at('/test/500').accepts('application/xml').with('Accept-Language' => 'en').get.should respond_with_status(500)
  
      req = @builder.debug.history(-4)
      req.get.should respond_with_status(200)
      req.path.should == '/test'
      req.host.to_s.should == @host + "/test"
      req.headers['Accept'].should == 'application/atom+xml'
      req.headers['Accept-Language'].should == 'en'
  
      req = @builder.history(-4)
      req.head.should respond_with_status(200)
      req.path.should == '/test'
      req.host.to_s.should == @host + "/test"
      req.headers['Accept'].should == 'text/html'
      req.headers['Accept-Language'].should == 'pt-BR'
  
      req = @builder.history(-4)
      req.post!.should respond_with_status(200)
      req.path.should == '/test'
      req.host.to_s.should == @host + "/test"
      req.headers['Accept'].should == 'application/xml'
      req.headers['Accept-Language'].should == 'en'
      req.headers['Content-Type'].should == 'application/xml'
  
      req = @builder.history(-4)
      req.get.should respond_with_status(500)
      req.path.should == '/test/500'
      req.host.to_s.should == @host + "/test/500"
      req.headers['Accept'].should == 'application/xml'
      req.headers['Accept-Language'].should == 'en'
  
      lambda { req.history(10).request }.should raise_error RuntimeError
    end 
  
  end
    
end

