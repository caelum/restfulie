module Restfulie::Client::HTTP#:nodoc:
  # inject new behavior in Atom instances to enable easily access to link relationships.
  ::Restfulie::Common::Representation::Atom::Link.instance_eval { include LinkRequestBuilder }
end