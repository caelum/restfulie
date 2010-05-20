class Hash
  def links(*args)
    links = fetch("link", [])
    links = [links] unless links.kind_of? Array
    links = [] unless links
    links = links.map do |l|
      Restfulie::Client::Link.new(l)
    end
    if args.empty?
      links
    else
      found = links.find do |link|
        link.rel == args[0].to_s
      end
      found
    end
  end
  def method_missing(sym, *args)
    self[sym.to_s].nil? ? super(sym, args) : self[sym.to_s]
  end
  def respond_to?(sym)
    include?(sym.to_s) || super(sym)
  end
end

module Restfulie::Common::Representation

  # Implements the interface for marshal Xml media type requests (application/xml)
  class XmlD
    cattr_reader :media_type_name
    @@media_type_name = 'application/xml'

    cattr_reader :headers
    @@headers = { 
      :post => { 'Content-Type' => media_type_name }
    }

    def unmarshal(string)
      Hash.from_xml(string)
    end

    def marshal(entity, rel)
      return entity if entity.kind_of? String
      entity.to_xml
    end

  end

end
