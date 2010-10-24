require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::HTTP do

  context 'RequestHistory' do
  
    before do
      @host = "http://localhost:4567"
    end
  
    it "should remember last requests" do
      r1 = Restfulie.at(@host).history.at('/test').accepts('application/atom+xml').with('Accept-Language' => 'en').get
      r1.should respond_with_status(200)
      r2 = r1.debug.at('/test').accepts('text/html').with('Accept-Language' => 'pt-BR').head
      r2.should respond_with_status(200)
      r3 = r2.at('/test').as('application/xml').with('Accept-Language' => 'en').delete!
      r3.should respond_with_status(200)
      r4 = r3.at('/test/500').accepts('application/xml').with('Accept-Language' => 'en').get
      r4.should respond_with_status(500)
  
      req = r4.debug.history(-4)
      req.get.should respond_with_status(200)
      req.path.should == '/test'
      req.host.to_s.should == @host + "/test"
      req.headers['Accept'].should == 'application/atom+xml'
      req.headers['Accept-Language'].should == 'en'
  
      req = req.history(-4)
      req.head.should respond_with_status(200)
      req.path.should == '/test'
      req.host.to_s.should == @host + "/test"
      req.headers['Accept'].should == 'text/html'
      req.headers['Accept-Language'].should == 'pt-BR'
  
      req = req.history(-4)
      req.post!.should respond_with_status(200)
      req.path.should == '/test'
      req.host.to_s.should == @host + "/test"
      req.headers['Accept'].should == 'application/xml'
      req.headers['Accept-Language'].should == 'en'
      req.headers['Content-Type'].should == 'application/xml'
  
      req = req.history(-4)
      req.get.should respond_with_status(500)
      req.path.should == '/test/500'
      req.host.to_s.should == @host + "/test/500"
      req.headers['Accept'].should == 'application/xml'
      req.headers['Accept-Language'].should == 'en'
  
      lambda { req.history(10).request }.should raise_error RuntimeError
    end 
  
  end
    
end

