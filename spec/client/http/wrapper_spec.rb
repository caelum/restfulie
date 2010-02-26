require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::HTTP do

  context "HTTP Base" do

    before(:all) do
      @host = "http://localhost:4567"
      @client = ::Restfulie::Client::HTTP::RequestExecutor.new(@host)
    end

    it "should get and respond 200 code" do
      @client.get("/test").code.to_i.should == 200
    end

    it "should post and respond 201 code" do
      @client.post("/test", "test").code.to_i.should == 201
    end

    it "should put and respond 200 code" do
      @client.put("/test", "test").code.to_i.should == 200
    end

    it "should delete and respond 200 code" do
      @client.delete("/test").code.to_i.should == 200
    end

  end

  context 'HTTP Builder' do

    before(:all) do
      @builder = ::Restfulie::Client::HTTP::RequestExecutorBuilder.new("http://localhost:4567")
    end

    it 'should get and respond 200 code' do
      @builder.at('/test/200').get.code.to_i.should == 200
      @builder.at('/test/200').accepts('application/xml').get.code.to_i.should == 200
      @builder.at('/test/200').as('application/xml').get.code.to_i.should == 200
      @builder.at('/test/200').with('Accept-Language' => 'en').get.code.to_i.should == 200
      @builder.at('/test/200').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').get.code.to_i.should == 200
    end

    it "should post and respond 201 code" do
      @builder.at("/test").post("test").code.to_i.should == 201
      @builder.at('/test').accepts('application/xml').post("test").code.to_i.should == 201
      @builder.at('/test').as('application/xml').post("test").code.to_i.should == 201
      @builder.at('/test').with('Accept-Language' => 'en').post("test").code.to_i.should == 201
      @builder.at('/test').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').post("test").code.to_i.should == 201
    end

    it "should put and respond 200 code" do
      @builder.at("/test").put("test").code.to_i.should == 200
      @builder.at('/test').accepts('application/xml').put("test").code.to_i.should == 200
      @builder.at('/test').as('application/xml').put("test").code.to_i.should == 200
      @builder.at('/test').with('Accept-Language' => 'en').put("test").code.to_i.should == 200
      @builder.at('/test').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').put("test").code.to_i.should == 200
    end

    it "should delete and respond 200 code" do
      @builder.at("/test").delete.code.to_i.should == 200
      @builder.at('/test').accepts('application/xml').delete.code.to_i.should == 200
      @builder.at('/test').as('application/xml').delete.code.to_i.should == 200
      @builder.at('/test').with('Accept-Language' => 'en').delete.code.to_i.should == 200
      @builder.at('/test').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').delete.code.to_i.should == 200
    end

  end

  context 'Response Handler' do

    class FakeResponse < ::Restfulie::Client::HTTP::Response
    end
    ::Restfulie::Client::HTTP::ResponseHandler.register(200,FakeResponse)

    before(:all) do
      @host = "http://localhost:4567"
      @client = ::Restfulie::Client::HTTP::RequestExecutor.new(@host)
    end

    it 'should respond FakeResponse' do
      @client.get('/test/200').class.should == FakeResponse
    end

    it 'should respond default Response' do
      @client.get('/test/299').class.should == ::Restfulie::Client::HTTP::Response
    end

  end

  context "error conditions" do

    before(:all) do
      @host = "http://localhost:4567"
      @client = ::Restfulie::Client::HTTP::RequestExecutor.new(@host)
    end

    it "raise Error::Redirection error when 300..399  code is returned" do
      lambda { @client.get("/test/302") }.should raise_error ::Restfulie::Client::HTTP::Error::Redirection
    end

    it "raise Error::BadRequest error when 400 code is returned" do
      lambda { @client.get("/test/400") }.should raise_error ::Restfulie::Client::HTTP::Error::BadRequest
    end

    it "raise Error::Unauthorized error when 401 code is returned" do
      lambda { @client.get("/test/401") }.should raise_error ::Restfulie::Client::HTTP::Error::Unauthorized
    end

    it "raise Error::Forbidden error when 403 code is returned" do
      lambda { @client.get("/test/403") }.should raise_error ::Restfulie::Client::HTTP::Error::Forbidden
    end

    it "raise Error::NotFound error when 404 code is returned" do
      lambda { @client.get("/test/404") }.should raise_error ::Restfulie::Client::HTTP::Error::NotFound
    end

    it "raise Error::MethodNotAllowed error when 405 code is returned" do
      lambda { @client.get("/test/405") }.should raise_error ::Restfulie::Client::HTTP::Error::MethodNotAllowed
    end

    it "raise Error::ProxyAuthenticationRequired error when 407 code is returned" do
      lambda { @client.get("/test/407") }.should raise_error ::Restfulie::Client::HTTP::Error::ProxyAuthenticationRequired
    end

    it "raise Error::Conflict error when 409 code is returned" do
     lambda { @client.get("/test/409") }.should raise_error ::Restfulie::Client::HTTP::Error::Conflict
    end

    it "raise Error::Gone error when 410 code is returned" do
     lambda { @client.get("/test/410") }.should raise_error ::Restfulie::Client::HTTP::Error::Gone
    end

    it "raise Error::PreconditionFailed error when 412 code is returned" do
      lambda { @client.get("/test/412") }.should raise_error ::Restfulie::Client::HTTP::Error::PreconditionFailed
    end

   it "raise Error::ClientError error when 413 code is returned" do
      lambda { @client.get("/test/413") }.should raise_error ::Restfulie::Client::HTTP::Error::ClientError
    end

   it "raise Error::NotImplemented error when 501 code is returned" do
      lambda { @client.get("/test/501") }.should raise_error ::Restfulie::Client::HTTP::Error::NotImplemented
    end

   it "raise Error::ServerError error when 500 code is returned" do
      lambda { @client.get("/test/500") }.should raise_error ::Restfulie::Client::HTTP::Error::ServerError
    end

   it "raise Error::ServerError error when 502..599 code is returned" do
      lambda { @client.get("/test/502") }.should raise_error ::Restfulie::Client::HTTP::Error::ServerError
    end

   it "raise Error::UnknownError error when 600 or bigger code is returned" do
      lambda { @client.get("/test/600") }.should raise_error ::Restfulie::Client::HTTP::Error::UnknownError
    end

  end
end

