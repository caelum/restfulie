class Restfulie::Builder::Rules::Namespace < Hash
  attr_reader :namespace
  attr_accessor :uri

  def initialize(ns, uri = nil, *args)
    @namespace = ns.to_sym
    @uri = uri
    super(*args)
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