module Restfulie
  class Transition
    attr_reader :body, :name, :result
    
    def initialize(name, options, result, body)
      @name = name
      @options = options
      @result = result
      @body = body
    end
    
    def action
      @options
    end
  end
end