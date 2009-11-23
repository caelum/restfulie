module Restfulie
  module State
    def respond_to?(sym)
      has_state(sym.to_s) || super(sym)
    end

    def has_state(name)
      !@_possible_states[name].nil?
    end
  end
end
