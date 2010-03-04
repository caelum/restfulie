module Restfulie::Client::ResponseBodyHandler

  class Base < ::Restfulie::Client::HTTP::Response
      
    @@body_handlers = {}

    def self.register(content_type,body_handler)
      @@body_handlers[content_type] = body_handler
    end

    def unmarshal
      content_type = headers['Content-Type'] || headers['content-type']
      body_handler = @@body_handlers[content_type]
      return Raw.new(self) unless body_handler
      unmarshaled = body_handler.unmarshal(self)
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

::Restfulie::Client::HTTP::ResponseHandler.register(200,::Restfulie::Client::ResponseBodyHandler::Base)

