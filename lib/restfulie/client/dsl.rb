module Restfulie::Client
  class Dsl

    def initialize
      @requests = []
      @responses = []
      trait :base
      trait :verb
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
    
    def trait(sym)
      t = "Restfulie::Client::Feature::#{sym.to_s.classify}".constantize
      self.extend t
      self
    end

    def method_missing(sym, *args)
      trait sym
    end
    
    def request_flow(env = {})
      Parser.new(@requests).continue(self, nil, env)
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
      filter.execute(self, *args)
    end
    
  end
end