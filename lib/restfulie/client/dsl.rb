module Restfulie::Client
  class Dsl

    def initialize
      @traits = []
      base
    end

    def method_missing(sym, *args)
      trait = "Restfulie::Client::Feature::#{sym.to_s.classify}".constantize
      @traits << trait
      self.extend trait
      self
    end

  end
end