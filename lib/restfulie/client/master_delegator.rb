class MasterDelegator

  alias_method :original_respond_to?, :respond_to?

  def respond_to?(sym)
    original_respond_to?(sym) || @requester.respond_to?(sym)
  end

  def method_missing(sym, *args, &block)
    if original_respond_to?(sym)
      result = super(sym, *args, &block)
    elsif @requester.respond_to?(sym)
      result = @requester.send(sym, *args, &block)
    else
      # let it go
      return super(sym, *args, &block)
    end
    delegate_parse result
  end
  
  protected
  
  def delegate(what, *args, &block)
    delegate_parse @requester.send(what, *args, &block)
  end
  
  def delegate_parse(result)
    (result == @requester) ? self : result
  end
  
end
