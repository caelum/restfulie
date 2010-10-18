class MasterDelegator

  alias_method :original_respond_to?, :respond_to?

  def respond_to?(sym)
    original_respond_to?(sym) || @requester.respond_to?(sym)
  end

  def method_missing(sym, *args, &block)
    if original_respond_to?(sym)
      super(sym, *args, &block)
    else @requester.respond_to?(sym)
      result = @requester.send(sym, *args, &block)
      result==@requester ? self : result
    end
  end
  
end
