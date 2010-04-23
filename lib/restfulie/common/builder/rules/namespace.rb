# Representation of a namespace. Allows any type of attribute setting and grabbing, i.e.:
#
# collection.namespace(:basket, "http://openbuy.com/basket") do |ns|
#   ns.price = @basket.cost
# end
#
# or
#
# collection.describe_members(:namespaces => "http://localhost:3000/items") do |member, item|
#   member.links << link( :rel => :self, :href => item_url(item))
# end
class Restfulie::Common::Builder::Rules::Namespace < Hash
  attr_reader :namespace
  attr_reader :uri

  def initialize(ns, uri, *args)
    @namespace = ns.to_sym
    self.uri = uri
    super(*args)
  end
  
  def uri=(value)
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