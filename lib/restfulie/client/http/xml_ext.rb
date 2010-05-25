module Restfulie::Client::HTTP#:nodoc:
  ::Hash.instance_eval {
    include Restfulie::Client::HTTP::LinkRequestBuilder
  }
end

class Link
  include ::Restfulie::Client::HTTP::LinkRequestBuilder

  def initialize(options = {})
    @options = options
  end
  def href
    @options["href"]
  end
  def rel
    @options["rel"]
  end
  def content_type
    @options["type"]
  end
end