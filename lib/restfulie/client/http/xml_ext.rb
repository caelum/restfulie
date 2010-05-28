module Restfulie::Client
end
module Restfulie::Client::HTTP#:nodoc:
  ::Hash.instance_eval {
    include Restfulie::Client::HTTP::LinkRequestBuilder
  }
end
