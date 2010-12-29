require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Restfulie::Client::HTTP do

  context "HTTP Base" do

    before do
      @host = "http://localhost:4567"
      @client = Restfulie.at(@host)
    end

    it "should get and respond 200 code" do
      @client.at("/test").get.should respond_with_status(200)
    end

    it "should put and respond 200 code" do
      @client.at("/test").as("text/plain").put("<test></test>").should respond_with_status(200)
    end

    it "should delete and respond 200 code" do
      @client.at("/test").delete.should respond_with_status(200)
    end

    it "should head and respond 200 code" do
      @client.at("/test").head.should respond_with_status(200)
    end

    it "should get! and respond 200 code" do
      @client.at("/test").get!.should respond_with_status(200)
    end

    it "should post! and respond 201 code" do
      pending "should use new style api"
      Restfulie.using{
        recipe
        request_marshaller
        verb_request
      }.at(@host).at("/test/redirect/songs").as("application/xml").post!("<test></text>").should respond_with_status(201)
    end

    it "should put! and respond 200 code" do
      @client.at("/test").as("application/xml").put!("<test></test>").should respond_with_status(200)
    end

    it "should delete! and respond 200 code" do
      @client.at("/test").delete!.should respond_with_status(200)
    end

    it "should head! and respond 200 code" do
      @client.at("/test").head!.should respond_with_status(200)
    end

  end

  #   
  #   context "On PUT" do
  #     it "should respond to 200 code" do
  #       builder.at("/test").put("test").should respond_with_status(200)
  #     end
  #     
  #     it "should accepts xml and respond to 200 code" do
  #       builder.at('/test').accepts('application/xml').put("test").should respond_with_status(200)
  #     end
  #     
  #     it "should respond to 200 code as xml" do
  #       builder.at('/test').as('application/xml').put("test").should respond_with_status(200)
  #     end
  #     
  #     it "should include accept language and respond 200" do
  #       builder.at('/test').with('Accept-Language' => 'en').put("test").should respond_with_status(200)
  #     end
  #     
  #     it "should respond 200 code as xml and accepts xml with en language" do
  #       builder.at('/test').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').put("test").should respond_with_status(200)
  #     end
  #     
  #     it "should respond 200 code as xml and accept atom and language" do
  #       builder.at('/test').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').put!("test").should respond_with_status(200)
  #     end
  #   end

  # context 'Response Handler' do
  # 
  #   class FakeResponse < ::Restfulie::Client::HTTP::Response
  #   end
  #   ::Restfulie::Client::HTTP::ResponseHandler.register(307,FakeResponse)
  # 
  #   let(:client) { Restfulie.at("http://localhost:4567") }
  # 
  #   it 'should have FakeResponder as Response Handler to 307' do
  #     ::Restfulie::Client::HTTP::ResponseHandler.handlers(307).should equal FakeResponse
  #   end
  # 
  #   it 'should respond FakeResponse' do
  #     client.at('/test/307').get.response.should be_kind_of FakeResponse
  #   end
  # 
  #   it 'should respond default Response' do
  #     client.at('/test/299').get.response.should be_kind_of ::Restfulie::Client::HTTP::Response
  #   end
  # 
  # end
  # 
end

