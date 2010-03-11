module Restfulie::Builder::Rules; end

class Restfulie::Builder::Rules::Base
  attr_accessor :blocks
  attr_accessor :links
  attr_reader :namespaces

  def initialize(&block)
    @links  = Restfulie::Builder::Rules::Links.new
    @blocks = block_given? ? [block] : []
    @namespaces = []
  end

  def apply(*args)
    @blocks.each do |block|
      block.call(self, *args)
    end
  end

  def namespace(ns, uri = nil,  &block)
    namespace = @namespaces.find { |n| n.namespace == ns } || (@namespaces << Restfulie::Builder::Rules::Namespace.new(ns)).first
    namespace.uri = uri
    yield(namespace) if block_given?
    namespace
  end
  
  def metaclass
    (class << self; self; end)
  end
end