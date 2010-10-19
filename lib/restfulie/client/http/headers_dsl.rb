require 'uri'

module Restfulie
  module Client
    module HTTP #:nodoc:
      # ==== HeadersDsl
      # Uses RequestAdapater to create a HTTP Request DSL 
      #
      # ==== Example:
      #
      #   @builder = ::Restfulie::Client::HTTP::RequestBuilderExecutor.new("http://restfulie.com") #this class includes HeadersDsl module.
      #   @builder.at('/posts').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').get.code #=> 200
      #
      class HeadersDsl < MasterDelegator
        
        def initialize(requester)
          @requester = requester
        end
      end
    end
  end
end
