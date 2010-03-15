module Restfulie::Builder::Rules; end

class Restfulie::Builder::Rules::Base
  attr_accessor :blocks
  attr_accessor :links
  attr_reader :namespaces

  def initialize(blocks = [], &block)
    @links  = Restfulie::Builder::Rules::Links.new
    @blocks = (block_given? ? [block] : []) + blocks
    @namespaces = []
  end

  def apply(*args)
    @blocks.each do |block|
      params = ([self] + args)[0..block.arity-1]
      block.call(*params)
    end
  end

  def namespace(ns, uri = nil,  &block)
    namespace = @namespaces.find { |n| n.namespace == ns } || (@namespaces << Restfulie::Builder::Rules::Namespace.new(ns)).first
    namespace.uri = uri unless uri.nil?
    yield(namespace) if block_given?
    namespace
  end
  
  def metaclass
    (class << self; self; end)
  end
end