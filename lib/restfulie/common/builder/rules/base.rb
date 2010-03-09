module Restfulie::Builder::Rules; end

class Restfulie::Builder::Rules::Base
  attr_accessor :links
  attr_reader :block

  def initialize(*args, &block)
    @links = Restfulie::Builder::Rules::Links.new
    @block = block
    @namespaces = []
  end

  def apply(*args)
    @block.call(self, *args) unless @block.nil?
  end

  def namespace(ns, uri = nil,  &block)
    namespace = @namespaces.find { |n| n.namespace == ns } || (@namespaces << Restfulie::Builder::Rules::Namespace.new(ns)).first
    namespace.uri = uri
    yield(namespace) if block_given?
    namespace
  end
end