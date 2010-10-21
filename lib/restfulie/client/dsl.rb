module Restfulie::Client
  class Dsl

    def initialize
      @requests = []
      @responses = []
      base
      request :base_request
      response :enhance_response
    end
    
    def request(what)
      req = "Restfulie::Client::Feature::#{what.to_s.classify}".constantize
      @requests << req
    end

    def response(what)
      response = "Restfulie::Client::Feature::#{what.to_s.classify}".constantize
      @requests << response
    end

    def method_missing(sym, *args)
      trait = "Restfulie::Client::Feature::#{sym.to_s.classify}".constantize
      self.extend trait
      self
    end
    
    def request_flow
      http_response = Parser.new(@requests).continue(self, nil)
      # response = Parser.new(@responses).continue(self, http_response)
    end

  end
  
  class Parser
    
    def initialize(stack)
      @stack = stack.dup
      @following = @stack.shift
    end
    
    def continue(*args)
      current = @following
      if current.nil?
        return args[2]
      end
      @following = @stack.shift
      filter = current.new
      # debugger
      filter.execute(self, *args)
    end
    
  end
end