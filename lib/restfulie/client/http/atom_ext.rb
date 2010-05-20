module Restfulie::Client::HTTP#:nodoc:

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
  ::Restfulie::Common::Representation::Atom::Link.instance_eval { include LinkRequestBuilder }
  
end
