class Restfulie::Common::Builder::Rules::Namespace < Hash
  attr_reader :namespace
  attr_reader :uri

  def initialize(ns, uri, *args)
    @namespace = ns.to_sym
    self.uri = uri
    super(*args)
  end
  
  def uri=(value)
    raise Restfulie::Common::Error::NameSpaceError.new('Namespace can not be blank uri.') if value.blank?
    @uri = value
  end

  def method_missing(symbol, *args)
    if ((key = symbol.to_s.match(/(.*)=/)) && args.size >= 1)
      self[key[1].to_sym] = args.first
    elsif(keys.include?(symbol))
      self[symbol]
    else
      super
    end
  end
end