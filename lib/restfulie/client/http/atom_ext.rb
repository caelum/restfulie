module Restfulie::Client::HTTP#:nodoc:

  # Offer easy access to Atom link relationships, such as <tt>post.next</tt> for 
  # <tt>&lt;link rel="next" href="http://resource.entrypoint.com/post/12" type="application/atom+xml" /&gt;</tt> relationships.
  module AtomLinkShortcut
    def method_missing(method_sym,*args)#:nodoc:
      selected_links = links.select{ |l| l.rel == method_sym.to_s }
      super if selected_links.empty?
      link = (selected_links.size == 1) ? selected_links.first : selected_links
      
      return link unless link.instance_variable_defined?(:@type)
      link.accepts(link.type)
      
      representation = Restfulie::Client::HTTP::RequestMarshaller.content_type_for(link.type)
      return representation.prepare_link_for(link) if representation
      link

    end
  end
  
  # Offers a way to access Atom entries element's in namespaced extensions.
  module AtomElementShortcut
    def method_missing(method_sym,*args)
      return super(method_sym, *args) unless simple_extensions
      
      found = find_extension_entry_for(method_sym)
      return super(method_sym, *args) if found.empty?
      result = found.collect do |pair|
        pair.last.length==1 ? pair.last.first : pair.last
      end
      result.length==1 ? result.first : result
    end
    
    def respond_to?(method_sym)
      return super(method_sym) unless simple_extensions

      found = find_extension_entry_for(method_sym)
      (found.length!=0) || super(method_sym)
    end
    
    private
    def find_extension_entry_for(method_sym)
      start = -(method_sym.to_s.length + 1)
      found = simple_extensions.select do |k, v|
        method_sym.to_s == k[start..-2]
      end
    end
  end

  # Gives to Atom::Link capabilities to fetch related resources.
  module LinkRequestBuilder
    include RequestMarshaller
    def path#:nodoc:
      at(href)
      super
    end
  end

  # inject new behavior in rAtom instances to enable easily access to link relationships.
  ::Atom::Feed.instance_eval {
    include AtomLinkShortcut
    include AtomElementShortcut
  }
  ::Atom::Entry.instance_eval {
    include AtomLinkShortcut
    include AtomElementShortcut
  }
  ::Atom::Link.instance_eval { include LinkRequestBuilder }
  
end
