module Restfulie
  module Client
    module HTTP #:nodoc:
      # Request Adapter provides a minimal interface to exchange information between server over HTTP protocol through simple adapters.
      # 
      # All the concrete adapters follow the interface laid down in this module.
      # Default connection provider is net/http
      #
      #==Example
      #
      #   @re = ::Restfulie::Client::HTTP::RequestExecutor.new('http://restfulie.com') #this class includes RequestAdapter module.
      #   puts @re.as('application/atom+xml').get!('/posts').title #=> 'Hello World!'
      #
      class RequestAdapter
        
        attr_accessor :cookies, :response_handler
        attr_writer   :default_headers

        def initialize
          @response_handler = Restfulie::Client::Response::CatchAndThrow.new
        end

      end
    end
  end
end
