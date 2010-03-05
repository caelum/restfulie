module Restfulie::Client::HTTP::Marshal

  module Atom

    def self.unmarshal(response)
      ::Atom::Feed.load_feed(response.body)
    end

    module AtomRequestBuilder
      include RequestBuilder
      def method_missing(method_sym,*args)
        selected_links = links.select{ |l| l.rel == method_sym.to_s }
        super if selected_links.empty?
        selected_links.size == 1 ? selected_links.first : selected_links
      end
    end

    module LinkRequestBuilder
      include RequestBuilder
      def path
        at(href)
        as(type) if type
        super
      end
    end
 
    ::Atom::Feed.instance_eval { include AtomRequestBuilder }
    ::Atom::Entry.instance_eval { include AtomRequestBuilder }
    ::Atom::Link.instance_eval { include LinkRequestBuilder }
  end

end

Restfulie::Client::HTTP::Marshal::Response.register('application/atom+xml',Restfulie::Client::HTTP::Marshal::Atom)

