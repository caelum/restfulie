module Restfulie::Client::HTTP#:nodoc:
  # inject new behavior in JsonLink instances to enable easily access to link relationships.
  ::Restfulie::Common::Representation::JsonLink.instance_eval { include LinkRequestBuilder }
end