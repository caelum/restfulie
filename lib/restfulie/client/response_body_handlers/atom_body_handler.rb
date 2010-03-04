module Restfulie::Client::ResponseBodyHandler

  module AtomBodyHandler

    def self.unmarshal(response)
      ::Atom::Feed.load_feed(response.body)
    end

    module AtomRequestBuilder
      include ::Restfulie::Client::RequestBuilderUnmarshal
      def method_missing(method_sym,*args)
        selected_links = links.select{ |l| l.rel == method_sym.to_s }
        super if selected_links.empty?
        selected_links.size == 1 ? selected_links.first : selected_links
      end
    end

    module LinkRequestBuilder
      include ::Restfulie::Client::RequestBuilderUnmarshal
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

  Base.register('application/atom+xml',AtomBodyHandler)
end
