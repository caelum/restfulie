module Restfulie::Client::HTTP::Marshal#:nodoc:

  #After request, using Restfulie::Client::HTTP::Marshal::Response, will call unmarshal method
  module RequestBuilder
    include ::Restfulie::Client::HTTP::RequestBuilder
    def request!(method, path, *args)#:nodoc:
      response = super(method, path, *args)
      response.unmarshal
    end
  end

  #After request response's body will be unmarshalled
  class Response < ::Restfulie::Client::HTTP::Response
        
    @@marshals = {}

    ## 
    # :singleton-method:
    # Use to register marshals
    #
    # * <tt>media type</tt>
    # * <tt>marshall</tt>
    #
    #==Example:
    #
    #   module FakeMarshal
    #    def self.unmarshal(response)
    #     ...
    #    end
    #   end
    #   
    #   Restfulie::Client::HTTP::Marshal::Response.register('application/atom+xml',FakeMarshal)
    #
    def self.register(content_type,marshal)
      @@marshals[content_type] = marshal
    end

    #Unmarshal resonse's body according content-type header.
    #If no marshal registered will return Raw instance
    def unmarshal
      content_type = headers['Content-Type'] || headers['content-type']
      marshal = @@marshals[content_type]
      return Raw.new(self) unless marshal
      unmarshaled = marshal.unmarshal(self)
      unmarshaled.extend(ResponseHolder)
      unmarshaled.response = self
      unmarshaled
    end

    #Ever unmarshaled response's body has an accessor to response
    module ResponseHolder
      attr_accessor :response
    end


    #If no marshal registered will return Raw instance
    class Raw
      attr_reader :response
      def initialize(response)
        @response = response
      end
    end

  end

end

Restfulie::Client::HTTP::ResponseHandler.register(200,Restfulie::Client::HTTP::Marshal::Response)

