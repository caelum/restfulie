class Hash
  def links(*args)
    links = fetch("link", [])
    Restfulie::Common::Converter::Xml::Links.new(links)
  end
  def method_missing(sym, *args)
    self[sym.to_s].nil? ? super(sym, args) : self[sym.to_s]
  end
  def respond_to?(sym)
    include?(sym.to_s) || super(sym)
  end
end
