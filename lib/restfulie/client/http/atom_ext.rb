module Restfulie::Client::HTTP#:nodoc:

  # Offer easily access to Atom link relationships, such as <tt>post.next</tt> for 
  # <tt>&lt;link rel="next" href="http://resource.entrypoint.com/post/12" type="application/atom+xml" /&gt;</tt> relationships.
  module AtomLinkShortcut
    def method_missing(method_sym,*args)#:nodoc:
      selected_links = links.select{ |l| l.rel == method_sym.to_s }
      super if selected_links.empty?
      selected_links.size == 1 ? selected_links.first : selected_links
    end
  end

  # Gives to Atom::Link capabilities to fetch related resources.
  module LinkRequestBuilder
    include RequestMarshaller
    def path#:nodoc:
      at(href)
      as(type) if type
      super
    end
  end

  # inject new behavior in rAtom instances to enable easily access to link relationships.
  ::Atom::Feed.instance_eval { include AtomLinkShortcut }
  ::Atom::Entry.instance_eval { include AtomLinkShortcut }
  ::Atom::Link.instance_eval { include LinkRequestBuilder }
  
end
