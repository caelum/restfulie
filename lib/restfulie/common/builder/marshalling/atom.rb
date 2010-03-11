class Restfulie::Builder::Marshalling::Atom < Restfulie::Builder::Marshalling::Base
  include ActionController::UrlWriter
  include Restfulie::Builder::Helpers
  
  ATOM_ATTRIBUTES = [
    :title, :id, :updated, # Required
    :author, :links, # Recommended
    :published, :category, :contributor, :rights # Optional
  ]
  
  ATOM_ATTRIBUTES_ENTRY = ATOM_ATTRIBUTES + [
    :content, :summary, # Required
    :source # Optional
  ]
  
  ATOM_ATTRIBUTES_FEED = ATOM_ATTRIBUTES + [
    :generator, :icon, :logo, :subtitle # Optional
  ]
  
  ATTRIBUTES_ALREADY_IN_ATOM_SPEC = [
    "id", "created_at", "updated_at", "title"
  ]

  def initialize(object, rule)
    @object = object
    @rule   = rule
  end

  def builder_member(options = {})
    if options[:eagerload] == true
      options[:eagerload] = [:values, :transitions]
    elsif options[:eagerload] == false
      options[:eagerload] = []
    end
    
    @rule.blocks.unshift(default_member_rule) if options[:default_rule]
    @rule.metaclass.send(:attr_accessor, *ATOM_ATTRIBUTES_ENTRY)
    @rule.apply(@object, options)

    entry_atom = ::Atom::Entry.new do |entry|
      entry.id     = @rule.id
      entry.title  = @rule.title
      entry.updated   = @rule.updated
      entry.published = @rule.published unless @rule.published.nil?
      
      # Namespaces
      @rule.namespaces.each do |ns|
        register_namespace(ns.namespace, ns.uri)
        ns.each do |key, value|
          register_element(ns.namespace, key)
          entry.send("#{ns.namespace}_#{key}=".to_sym, value)
        end
      end

      # Transitions
      @rule.links.each do |link|
        href = link.href || polymorphic_url(@object, :host => host)
        entry.links << ::Atom::Link.new(:rel => link.rel, :href => href, :type => link.type)
      end
    end

    entry_atom.to_xml
  end

  def default_member_rule
    @default_member_rule ||= Proc.new do |member_rule, object, options|
      # Default values
      member_rule.id        = polymorphic_url(object, :host => host)
      member_rule.title     = object.respond_to?(:title) && !object.title.nil? ? object.title : "Entry about #{object.class.to_s.demodulize}"
      member_rule.published = object.created_at
      member_rule.updated   = object.updated_at
      
      # Namespace
      if options[:eagerload].include?(:values)
        klass = object.class.to_s.demodulize.downcase.to_sym
        uri   = polymorphic_url(klass.to_s.pluralize, :host => host)
        member_rule.namespace(klass, uri) do |namespace|
          attributes = object.class.column_names - ATTRIBUTES_ALREADY_IN_ATOM_SPEC
          attributes.each { |attr| namespace.send("#{attr}=", object[attr]) }
        end
      end

      member_rule.links << link(:rel => :self, :type => 'application/atom+xml')
    end
  end

private

  def host
    "localhost"
  end

  def register_namespace(namespace, uri)
    ::Atom::Entry.add_extension_namespace(namespace, uri) unless ::Atom::Entry.known_namespaces.include? uri
  end

  def register_element(namespace, attribute)
    attribute = "#{namespace}:#{attribute}"
    ::Atom::Entry.element(attribute) if element_unregistered?(attribute)
  end

  def element_unregistered?(element)
    ::Atom::Entry.element_specs.select { |k,v|  v.name == element }.empty?
  end
  
end