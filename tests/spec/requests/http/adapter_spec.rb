require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::HTTP do

  context "HTTP Base" do

    before(:all) do
      @host = "http://localhost:4567"
      @client = Restfulie.at(@host)
    end

    it "should get and respond 200 code" do
      @client.get("/test").should respond_with_status(200)
    end

    it "should put and respond 200 code" do
      @client.put("/test", "test").should respond_with_status(200)
    end

    it "should delete and respond 200 code" do
      @client.delete("/test").should respond_with_status(200)
    end

    it "should head and respond 200 code" do
      @client.head("/test").should respond_with_status(200)
    end

    it "should get! and respond 200 code" do
      @client.get!("/test").should respond_with_status(200)
    end

    it "should post! and respond 201 code" do
      @client.post!("/test", "test").should respond_with_status(201)
    end

    it "should put! and respond 200 code" do
      @client.put!("/test", "test").should respond_with_status(200)
    end

    it "should delete! and respond 200 code" do
      @client.delete!("/test").should respond_with_status(200)
    end

    it "should head! and respond 200 code" do
      @client.head!("/test").should respond_with_status(200)
    end

  end

  context 'HTTP Builder' do

    let(:builder) { ::Restfulie::Client::HTTP::RequestBuilderExecutor.new("http://localhost:4567") }
    
    context "On GET" do
      
      it "should respond to 200 code" do
        builder.at('/test/200').get.should respond_with_status(200)
      end
      
      it "should accepts and respond to 200 code on xml" do
        builder.at('/test/200').accepts('application/xml').get.should respond_with_status(200)
      end
      
      it "should respond to 200 code as xml" do
        builder.at('/test/200').as('application/xml').get.should respond_with_status(200)
      end
      
      it "should accept language and respond 200" do
        builder.at('/test/200').with('Accept-Language' => 'en').get.should respond_with_status(200)
      end
      
      it "should respond 200 code as xml and accept atom and language" do
        builder.at('/test/200').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').get.should respond_with_status(200)
      end
      
    end
    
    context "On PUT" do
      it "should respond to 200 code" do
        builder.at("/test").put("test").should respond_with_status(200)
      end
      
      it "should accepts xml and respond to 200 code" do
        builder.at('/test').accepts('application/xml').put("test").should respond_with_status(200)
      end
      
      it "should respond to 200 code as xml" do
        builder.at('/test').as('application/xml').put("test").should respond_with_status(200)
      end
      
      it "should include accept language and respond 200" do
        builder.at('/test').with('Accept-Language' => 'en').put("test").should respond_with_status(200)
      end
      
      it "should respond 200 code as xml and accepts xml with en language" do
        builder.at('/test').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').put("test").should respond_with_status(200)
      end
      
      it "should respond 200 code as xml and accept atom and language" do
        builder.at('/test').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').put!("test").should respond_with_status(200)
      end
    end
    
    context "On DELETE" do
      
      it "should respond 200 code" do
        builder.at("/test").delete.should respond_with_status(200)
      end
      
      it "should accepts xml and respond 200 code" do
        builder.at('/test').accepts('application/xml').delete.should respond_with_status(200)
      end
      
      it "as xml should respond 200 code" do
        builder.at('/test').as('application/xml').delete.should respond_with_status(200)
      end
      
      it "should respond 200 code with accept language en" do
        builder.at('/test').with('Accept-Language' => 'en').delete.should respond_with_status(200)
      end
      
      it "should respond 200 code as xml accepts atom+xml with accept language en" do
        builder.at('/test').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').delete.should respond_with_status(200)
      end
      
    end

    context "On HEAD" do
      
      it "should respond 200 code" do
        builder.at("/test").head.should respond_with_status(200) 
      end
      
      it "should respond 200 code and accepts xml" do
        builder.at('/test').accepts('application/xml').head.should respond_with_status(200) 
      end
      
      it "should respond 200 code as xml" do
        builder.at('/test').as('application/xml').head.should respond_with_status(200)
      end
      
      it "should respond 200 code with accept language en" do
        builder.at('/test').with('Accept-Language' => 'en').head.should respond_with_status(200)
      end
      
      it "should respond 200 code as xml and accepts atom+xml with accepts language en" do
        builder.at('/test').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').head.should respond_with_status(200)
      end
      
      it "should respond 200 code as xml and accepts atom+xml with accepts language en in a destructive method" do
        builder.at('/test').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').head!.should respond_with_status(200)
      end
      
    end

  end

  context 'RequestHistory' do

    before(:all) do
      @host = "http://localhost:4567"
      @builder = ::Restfulie::Client::HTTP::RequestHistoryExecutor.new(@host)
    end

    it "should remember last requests" do
      @builder.at('/test').accepts('application/atom+xml').with('Accept-Language' => 'en').get.should respond_with_status(200)
      @builder.at('/test').accepts('text/html').with('Accept-Language' => 'pt-BR').head.should respond_with_status(200)
      @builder.at('/test').as('application/xml').with('Accept-Language' => 'en').post('test').should respond_with_status(201)
      @builder.at('/test/500').accepts('application/xml').with('Accept-Language' => 'en').get.should respond_with_status(500)

      @builder.history(0).request.should respond_with_status(200)
      @builder.path.should == '/test'
      @builder.host.to_s.should == @host
      @builder.headers['Accept'].should == 'application/atom+xml'
      @builder.headers['Accept-Language'].should == 'en'

      @builder.history(1).request.should respond_with_status(200)
      @builder.path.should == '/test'
      @builder.host.to_s.should == @host
      @builder.headers['Accept'].should == 'text/html'
      @builder.headers['Accept-Language'].should == 'pt-BR'

      @builder.history(2).request.should respond_with_status(201)
      @builder.path.should == '/test'
      @builder.host.to_s.should == @host
      @builder.headers['Accept'].should == 'application/xml'
      @builder.headers['Accept-Language'].should == 'en'
      @builder.headers['Content-Type'].should == 'application/xml'

      @builder.history(3).request.should respond_with_status(500)
      @builder.path.should == '/test/500'
      @builder.host.to_s.should == @host
      @builder.headers['Accept'].should == 'application/xml'
      @builder.headers['Accept-Language'].should == 'en'

      lambda { @builder.history(10).request }.should raise_error RuntimeError
    end 

  end

  context 'Response Handler' do

    class FakeResponse < ::Restfulie::Client::HTTP::Response
    end
    ::Restfulie::Client::HTTP::ResponseHandler.register(701,FakeResponse)

    let(:client) { ::Restfulie::Client::HTTP::RequestExecutor.new(::URI.parse("http://localhost:4567")) }

    it 'should have FakeResponder as Response Handler to 201' do
      ::Restfulie::Client::HTTP::ResponseHandler.handlers(701).should equal FakeResponse
    end

    it 'should respond FakeResponse' do
      client.get('/test/701')[2].class.should equal FakeResponse
    end

    it 'should respond default Response' do
      client.get('/test/299')[2].class.should equal ::Restfulie::Client::HTTP::Response
    end

  end

  context "redirection" do
    
    let(:resp) { Restfulie.at("http://localhost:4567/test_redirection").follow.get! }
    
    it "should follow redirection" do
      resp.response.path.should == "/redirected"
    end
    
    it "should set the body as 'OK'" do
      resp.response.body.should == "OK"
    end
    
  end

  context "error conditions" do

    before(:all) do
      @host = "http://localhost:4567"
      @client = ::Restfulie::Client::HTTP::RequestExecutor.new(@host)
    end

    it "raise Error::Redirection error when 300..399  code is returned" do
      @client.get("/test/302").should respond_with_status(302)
      lambda { @client.get!("/test/302") }.should raise_exception ::Restfulie::Client::HTTP::Error::Redirection
    end

    it "raise Error::BadRequest error when 400 code is returned" do
      @client.get("/test/400").should respond_with_status(400)
      lambda { @client.get!("/test/400") }.should raise_exception ::Restfulie::Client::HTTP::Error::BadRequest
    end

    it "raise Error::Unauthorized error when 401 code is returned" do
      @client.get("/test/401").should respond_with_status(401)
      lambda { @client.get!("/test/401") }.should raise_exception ::Restfulie::Client::HTTP::Error::Unauthorized
    end

    it "raise Error::Forbidden error when 403 code is returned" do
      @client.get("/test/403").should respond_with_status(403)
      lambda { @client.get!("/test/403") }.should raise_exception ::Restfulie::Client::HTTP::Error::Forbidden
    end

    it "raise Error::NotFound error when 404 code is returned" do
      @client.get("/test/404").should respond_with_status(404)
      lambda { @client.get!("/test/404") }.should raise_exception ::Restfulie::Client::HTTP::Error::NotFound
    end

    it "raise Error::MethodNotAllowed error when 405 code is returned" do
      @client.get("/test/405").should respond_with_status(405)
      lambda { @client.get!("/test/405") }.should raise_exception ::Restfulie::Client::HTTP::Error::MethodNotAllowed
    end

    it "raise Error::ProxyAuthenticationRequired error when 407 code is returned" do
      @client.get("/test/407").should respond_with_status(407)
      lambda { @client.get!("/test/407") }.should raise_exception ::Restfulie::Client::HTTP::Error::ProxyAuthenticationRequired
    end

    it "raise Error::Conflict error when 409 code is returned" do
      @client.get("/test/409").should respond_with_status(409)
     lambda { @client.get!("/test/409") }.should raise_exception ::Restfulie::Client::HTTP::Error::Conflict
    end

    it "raise Error::Gone error when 410 code is returned" do
      @client.get("/test/410").should respond_with_status(410)
     lambda { @client.get!("/test/410") }.should raise_exception ::Restfulie::Client::HTTP::Error::Gone
    end

    it "raise Error::PreconditionFailed error when 412 code is returned" do
      @client.get("/test/412").should respond_with_status(412)
      lambda { @client.get!("/test/412") }.should raise_exception ::Restfulie::Client::HTTP::Error::PreconditionFailed
    end

   it "raise Error::ClientError error when 413 code is returned" do
      @client.get("/test/413").should respond_with_status(413)
      lambda { @client.get!("/test/413") }.should raise_exception ::Restfulie::Client::HTTP::Error::ClientError
    end

   it "raise Error::NotImplemented error when 501 code is returned" do
      @client.get("/test/501").should respond_with_status(501)
      lambda { @client.get!("/test/501") }.should raise_exception ::Restfulie::Client::HTTP::Error::NotImplemented
    end

   it "raise Error::ServerError error when 500 code is returned" do
      @client.get("/test/500").should respond_with_status(500)
      lambda { @client.get!("/test/500") }.should raise_exception ::Restfulie::Client::HTTP::Error::ServerError
    end

   it "raise Error::ServerNotAvailableError error when 503 code is returned" do
      @client.get(nil,nil).should respond_with_status(503)
      lambda { @client.get!(nil,nil) }.should raise_exception ::Restfulie::Client::HTTP::Error::ServerNotAvailableError
    end

   it "raise Error::ServerError error when 502..599 code is returned" do
     @client.get("/test/502").should respond_with_status(502)
      lambda { @client.get!("/test/502") }.should raise_exception ::Restfulie::Client::HTTP::Error::ServerError
    end

   it "raise Error::UnknownError error when 600 or bigger code is returned" do
     @client.get("/test/600").should respond_with_status(600)
      lambda { @client.get!("/test/600") }.should raise_exception ::Restfulie::Client::HTTP::Error::UnknownError
    end

  end
end

