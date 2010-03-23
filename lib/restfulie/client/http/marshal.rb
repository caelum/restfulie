module Restfulie::Client::HTTP::Marshal#:nodoc:

  #Custom request builder for marshalled data that unmarshalls content after receiving it.
  module RequestBuilder
    include ::Restfulie::Client::HTTP::RequestBuilder
    
    # executes super and unmarshalls it
    def request!(method, path, *args)
      response = super(method, path, *args)
      response.unmarshal(@raw)
    end
  end

  # Class responsible for unmarshalling a response
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
    def unmarshal(force_raw)
      content_type = headers['Content-Type'] || headers['content-type']
      marshaller = @@marshals[content_type] || Raw
      marshaller = Raw if force_raw
      unmarshaled = marshaller.unmarshal(self)
      unmarshaled.extend(ResponseHolder)
      unmarshaled.response = self
      unmarshaled
    end

    #Every unmarshaled response's body has an accessor to response
    module ResponseHolder
      attr_accessor :response
    end


    #If no marshaller is registered, Restfulie returns an instance of Raw
    class Raw
      
      #Creates a new Raw instance.
      def self.unmarshal(response)
        Raw.new
      end
    end

  end

end

Restfulie::Client::HTTP::ResponseHandler.register(200,Restfulie::Client::HTTP::Marshal::Response)

