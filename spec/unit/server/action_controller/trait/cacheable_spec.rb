require 'spec_helper'

describe Restfulie::Server::ActionController::Trait::Cacheable do

  context "using a Trait::Cacheable responder" do


    module ToFormatReceiver
      attr_accessor :received
      def to_format
        @received = true
      end
    end

    let(:responder) do
      responder = Object.new
      responder.extend ToFormatReceiver
      responder.extend ::Restfulie::Server::ActionController::Trait::Cacheable
    end

    it "should superize if not cached" do
      responder.stub(:is_cached?).and_return(false)
      responder.stub(:cache_request).and_return("")

      responder.to_format
      responder.received.should be_true
    end


    it "should cache requests" do
      responder.stub(:is_cached?).and_return(false)
      
      @fake_headers = "cache me!"
      responder.stub(:cache_control_headers).and_return(@fake_headers)
      
      expires_mock = double('Expires')
      expires_mock.should_receive(:do_http_cache).with(responder, @fake_headers)

      last_modifieds = double('Last Modifies')
      last_modifieds.should_receive(:do_http_cache).with(responder, @fake_headers)
      
      responder.stub(:caches).and_return([expires_mock, last_modifieds])

      responder.to_format
    end

  end
end