class MasterDelegator

  def method_missing(sym, *args, &block)
    if respond_to?(sym)
      super(sym, *args, &block)
    else @requester.respond_to?(sym)
      @requester.send(sym, *args, &block)
    end
  end
  
  def respond_to?(sym)
    respond_to?(sym) || @requester.respond_to?(sym)
  end
  
end
