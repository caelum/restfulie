module Restfulie::Builder::Rules; end

class Restfulie::Builder::Rules::Base
  attr_accessor :blocks

  # Required
  attr_accessor :title, :id, :updated

  # Recommended
  attr_accessor :author, :links

  # Optional
  attr_accessor :published
  # attr_accessor :category, :contributor, :rights # Not implemented

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
end