module Restfulie::Common::Builder::Rules; end

class Restfulie::Common::Builder::Rules::Base
  attr_accessor :blocks
  attr_accessor :links
  attr_reader :namespaces

  def initialize(blocks = [], &block)
    @links  = Restfulie::Common::Builder::Rules::Links.new
    @blocks = (block_given? ? [block] : []) + blocks
    @namespaces = []
  end

  def apply(*args)
    @blocks.each do |block|
      params = ([self] + args)[0..block.arity-1]
      block.call(*params)
    end
  end

  # Use to register namespace
  #
  #==Example:
  #
  # namespace(@album , "http://example.com")
  # namespace(:albums, "http://example.com")
  # namespace(:albums, "http://example.com", :eager_load => false)
  # namespace(:albums, "http://example.com", :eager_load => { :title => 'A title' })
  #
  def namespace(ns, uri = nil, options = {}, &block)
    object = nil
    
    if !ns.kind_of?(String) && !ns.kind_of?(Symbol)
      object = ns
      ns = object.class.to_s.demodulize.downcase.pluralize.to_sym
      options[:eager_load] = true unless options.key?(:eager_load)
    end
    
    unless [true, false, nil].include?(options[:eager_load])
      object = options[:eager_load]
      options[:eager_load] = true
    end
    
    namespace = find_or_new_namespace(ns, uri)
    eager_load(object, namespace) if options[:eager_load]
    
    yield(namespace) if block_given?
    namespace
  end

  def metaclass
    (class << self; self; end)
  end

private
  # Load attributes of the object to passed hash.
  # If object respond to attributes, attributes is merge, unless merge instance variables
  def eager_load(object, ns)
    if object.kind_of?(Hash)
      ns.merge!(object.symbolize_keys)
    elsif object.respond_to?(:attributes)
      ns.merge!(object.attributes.symbolize_keys)
    else
      object.instance_variables.each do |var|
        ns[var.gsub(/^@/, '').to_sym] = object.instance_variable_get(var)
      end
    end
  end

  # Search a namespace or create a new
  def find_or_new_namespace(name, uri)
    namespace = @namespaces.find { |n| n.namespace == name } || (@namespaces << Restfulie::Common::Builder::Rules::Namespace.new(name, uri)).last
    namespace.uri = uri unless uri.nil?
    namespace
  end
end