module Restfulie::Client
  class Dsl

    def initialize
      @requests = []
      trait :base
      trait :verb
      request :base_request
      request :enhance_response
    end
    
    def request(what)
      req = "Restfulie::Client::Feature::#{what.to_s.classify}".constantize
      @requests << req
      self
    end

    def trait(sym)
      t = "Restfulie::Client::Feature::#{sym.to_s.classify}".constantize
      self.extend t
      self
    end

    def method_missing(sym, *args)
      if Restfulie::Client::Feature.const_defined? sym.to_s.classify
        loaded = true
        trait sym
      end
      if Restfulie::Client::Feature.const_defined? "#{sym.to_s.classify}Request"
        loaded = true
        request "#{sym.to_s}Request"
      end
      if loaded
        self
      else
        super sym, *args
      end
    end
    
    def request_flow(env = {})
      Parser.new(@requests).continue(self, nil, env)
    end

  end
  
  class Parser
    
    def initialize(stack)
      @stack = stack.dup
    end
    
    def continue(request, response, env)
      current = @stack.pop
      if current.nil?
        return response
      end
      filter = current.new
      filter.execute(self, request, response, env)
    end
    
  end
end