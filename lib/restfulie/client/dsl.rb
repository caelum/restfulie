module Restfulie::Client
  class Dsl

    def initialize
      @requests = []
      base
    end

    def method_missing(sym, *args)
      request = "Restfulie::Client::Feature::#{sym.to_s.classify}Request".constantize
      @requests << request
      
      trait = "Restfulie::Client::Feature::#{sym.to_s.classify}".constantize
      self.extend trait
      self
    end
    
    def request_flow
      Parser.new(@requests).continue(self)
    end

  end
  
  class Parser
    
    def initialize(stack)
      @stack = stack.dup
      @following = @stack.shift
    end
    
    def continue(request)
      current = @following
      if @following==nil
        return "finished"
      end
      @following = @stack.shift
      current.new.execute(self, @request)
    end
    
  end
end