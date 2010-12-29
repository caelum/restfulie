require 'spec_helper'

describe Restfulie::Client::HTTP do

  context "error conditions" do
  
    before do
      @host = "http://localhost:4567"
      @client = Restfulie.at(@host)
    end
  
    it "receives error when 300..399  code is returned" do
      @client.at("/test/302").get.should respond_with_status(302)
    end
    it "raise Error::Redirection error when 300..399  code is returned" do
      lambda { @client.at("/test/302").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::Redirection
    end
  
    it "raise Error::BadRequest error when 400 code is returned" do
      @client.at("/test/400").get.should respond_with_status(400)
    end
    it "receives error when 400 code is returned" do
      lambda { @client.at("/test/400").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::BadRequest
    end
  
    it "raise Error::Unauthorized error when 401 code is returned" do
      @client.at("/test/401").get.should respond_with_status(401)
    end
    it "receives error when 401 code is returned" do
      lambda { @client.at("/test/401").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::Unauthorized
    end
  
    it "raise Error::Forbidden error when 403 code is returned" do
      @client.at("/test/403").get.should respond_with_status(403)
    end
    
    it "receives error when 403 code is returned" do
      lambda { Restfulie.at("http://localhost:4567/test/403").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::Forbidden
    end
  
    it "raise Error::NotFound error when 404 code is returned" do
      @client.at("/test/404").get.should respond_with_status(404)
    end
    it "receives error when 404 code is returned" do
      lambda { @client.at("/test/404").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::NotFound
    end
  
    it "raise Error::MethodNotAllowed error when 405 code is returned" do
      @client.at("/test/405").get.should respond_with_status(405)
    end
    it "receives error when 405 code is returned" do
      lambda { @client.at("/test/405").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::MethodNotAllowed
    end
  
    it "raise Error::ProxyAuthenticationRequired error when 407 code is returned" do
      @client.at("/test/407").get.should respond_with_status(407)
    end
    it "receives error when 407 code is returned" do
      lambda { @client.at("/test/407").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::ProxyAuthenticationRequired
    end
  
    it "receives error when 409 code is returned" do
      @client.at("/test/409").get.should respond_with_status(409)
    end
    
    it "raise Error::Conflict error when 409 code is returned" do
     lambda { @client.at("/test/409").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::Conflict
    end
  
    it "raise Error::Gone error when 410 code is returned" do
      @client.at("/test/410").get.should respond_with_status(410)
    end
    it "receives error when 410 code is returned" do
     lambda { @client.at("/test/410").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::Gone
    end
  
    it "raise Error::PreconditionFailed error when 412 code is returned" do
      @client.at("/test/412").get.should respond_with_status(412)
    end
    it "receives error when 412 code is returned" do
      lambda { @client.at("/test/412").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::PreconditionFailed
    end
  
   it "receives error when 413 code is returned" do
      @client.at("/test/413").get.should respond_with_status(413)
    end
    it "raise Error::ClientError error when 413 code is returned" do
      lambda { @client.at("/test/413").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::ClientError
    end
  
   it "receives error when 501 code is returned" do
      @client.at("/test/501").get.should respond_with_status(501)
    end
    it "raise Error::NotImplemented error when 501 code is returned" do
      lambda { @client.at("/test/501").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::NotImplemented
    end
  
   it "receives error when 500 code is returned" do
      @client.at("/test/500").get.should respond_with_status(500)
    end
    it "raise Error::ServerError error when 500 code is returned" do
      lambda { @client.at("/test/500").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::ServerError
    end
  
   it "receives error when 503 code is returned" do
     pending "should treat it well when the server is not there..."
      Restfulie.at("http://localhost:2222/").get.should respond_with_status(503)
    end
    
    it "raise Error::ServerNotAvailableError error when 503 code is returned" do
      lambda { Restfulie.at("http://localhost:2222/").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::ServerNotAvailableError
    end
  
   it "receives error when 502..599 code is returned" do
     @client.at("/test/502").get.should respond_with_status(502)
   end
   it "raise Error::ServerError error when 502..599 code is returned" do
      lambda { @client.at("/test/502").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::ServerError
    end
  
   it "receives error when 600 or bigger code is returned" do
     @client.at("/test/600").get.should respond_with_status(600)
   end
   it "raise Error::UnknownError error when 600 or bigger code is returned" do
      lambda { @client.at("/test/600").get! }.should raise_exception ::Restfulie::Client::HTTP::Error::UnknownError
    end
  
  end
end

