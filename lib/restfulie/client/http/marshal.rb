module Restfulie::Client::HTTP::Marshal

  module RequestBuilder
    include ::Restfulie::Client::HTTP::RequestBuilder
    def request!(method, path, *args)
      response = super(method, path, *args)
      response.unmarshal
    end
  end

  class Response < ::Restfulie::Client::HTTP::Response
        
    @@marshals = {}

    def self.register(content_type,marshal)
      @@marshals[content_type] = marshal
    end

    def unmarshal
      content_type = headers['Content-Type'] || headers['content-type']
      marshal = @@marshals[content_type]
      return Raw.new(self) unless marshal
      unmarshaled = marshal.unmarshal(self)
      unmarshaled.extend(ResponseHolder)
      unmarshaled.response = self
      unmarshaled
    end

    module ResponseHolder
      attr_accessor :response
    end

    class Raw
      attr_reader :response
      def initialize(response)
        @response = response
      end
    end

  end

end

Restfulie::Client::HTTP::ResponseHandler.register(200,Restfulie::Client::HTTP::Marshal::Response)

