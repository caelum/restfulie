module Restfulie
  module Client
    module HTTP #:nodoc:
      #=ResponseHandler
      # You can change instance registering a class according to the code.
      #
      #==Example
      #
      #   class RequestExecutor
      #     include RequestAdapter
      #     def initialize(host)
      #       self.host=host
      #     end
      #   end
      #
      #   class FakeResponse < Restfulie::Client::HTTP::Response
      #   end
      #
      #   Restfulie::Client::HTTP::ResponseHandler.register(201,FakeResponse)  
      #   @re = Restfulie::Client::HTTP::RequestExecutor.new('http://restfulie.com')
      #   puts @re.as('application/atom+xml').get!('/posts').class.to_i #=> FakeResponse
      #
      module ResponseHandler
        @@response_handlers = {}
        ## 
        # :singleton-method:
        # Response handlers attribute reader
        # * code: HTTP status code
        def self.handlers(code)
          @@response_handlers[code] 
        end
  
        ## 
        # :singleton-method:
        # Use to register response handlers
        #
        # * <tt>code: HTTP status code</tt>
        # * <tt>response_class: Response class</tt>
        #
        #==Example:
        #   class FakeResponse < ::Restfulie::Client::HTTP::Response
        #   end
        #
        #   Restfulie::Client::HTTP::ResponseHandler.register(200,FakeResponse)  
        #
        def self.register(code,response_class)
          @@response_handlers[code] = response_class 
        end
  
        ## 
        # :singleton-method:
        # Request Adapter uses this method to choose response instance
        #
        # *<tt>method: :get,:post,:delete,:head,:put</tt>
        # *<tt>path: '/posts'</tt>
        # *<tt>http_response</tt>
        #
        def self.handle(method, path, http_response)
          response_class = @@response_handlers[http_response.code.to_i] || Response
          headers = {}
          http_response.header.each { |k, v| headers[k] = v }
          response_class.new( method, path, http_response.code.to_i, http_response.body, headers)
        end
      end
    end
  end
end
