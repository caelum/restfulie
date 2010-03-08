module Restfulie::Client::HTTP::Marshal

  # Implements the interface for unmarshal Atom media type responses (application/atom+xml) to ruby objects instantiated by rAtom library.
  #
  # Furthermore, this module extends rAtom behavior to enable client users to easily access link relationships.
  module Atom

    # convert raw body responses to rAtom instances
    def self.unmarshal(response)
      ::Atom::Feed.load_feed(response.body)
    end

    module AtomRequestBuilder
      include RequestBuilder
      
      # Offer easily access to Atom link relationships, such as <tt>post.next</tt> for 
      # <tt>&lt;link rel="next" href="http://resource.entrypoint.com/post/12" type="application/atom+xml" /&gt;</tt> relationships.
      def method_missing(method_sym,*args)
        selected_links = links.select{ |l| l.rel == method_sym.to_s }
        super if selected_links.empty?
        selected_links.size == 1 ? selected_links.first : selected_links
      end
    end

    # Gives RequestBuilder module capabilities to Atom::Link to allow easy fetching of the resources related to current resource.
    module LinkRequestBuilder
      include RequestBuilder
      def path
        at(href)
        as(type) if type
        super
      end
    end
 
    # inject new behavior in rAtom instances to enable easily access to link relationships.
    ::Atom::Feed.instance_eval { include AtomRequestBuilder }
    ::Atom::Entry.instance_eval { include AtomRequestBuilder }
    ::Atom::Link.instance_eval { include LinkRequestBuilder }
  end

end

# Register this handler for application/atom+xml response types
Restfulie::Client::HTTP::Marshal::Response.register('application/atom+xml',Restfulie::Client::HTTP::Marshal::Atom)
