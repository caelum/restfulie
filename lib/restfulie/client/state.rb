# adds respond_to and has_state methods to resources
module Restfulie::Client::State
  # overrides the respond_to? method to check if this method is contained or was defined by a state
  def respond_to?(sym)
    has_state(sym.to_s) || super(sym)
  end

  # returns true if this resource has a state named name
  def has_state(name)
    !@existing_relations[name].nil?
  end
end
