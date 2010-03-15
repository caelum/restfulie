class Restfulie::Builder::Marshalling::Atom < Restfulie::Builder::Marshalling::Base
  include ActionController::UrlWriter
  include Restfulie::Builder::Helpers
  
  ATOM_ATTRIBUTES = [
    :title, :id, :updated, # Required
    :author, :links, # Recommended
    :category, :contributor, :rights # Optional
  ]
  
  ATOM_ATTRIBUTES_ENTRY = ATOM_ATTRIBUTES + [
    :content, :summary, # Required
    :published, :source # Optional
  ]
  
  ATOM_ATTRIBUTES_FEED = ATOM_ATTRIBUTES + [
    :generator, :icon, :logo, :subtitle # Optional
  ]
  
  ATTRIBUTES_ALREADY_IN_ATOM_SPEC = [
    "id", "created_at", "updated_at", "title"
  ]

  def initialize(object, rules)
    @object = object
    @rules   = rules
  end

  def builder_collection(options = {})
    builder_feed(@object, @rules, options).to_xml
  end

  def builder_member(options = {})
    builder_entry(@object, @rules, options).to_xml
  end

private

  def builder_feed(objects, rules_blocks, options = {})
    rule = Restfulie::Builder::CollectionRule.new(rules_blocks)
    options = eagerload_enhance(options)
    
    rule.blocks.unshift(default_collection_rule) if options[:default_rule]
    rule.metaclass.send(:attr_accessor, *ATOM_ATTRIBUTES_FEED)
    rule.apply(objects, options)
    
    atom = ::Atom::Feed.new do |feed|
      # Set values
      (ATOM_ATTRIBUTES_FEED - [:links]).each do |field|
        feed.send("#{field}=".to_sym, rule.send(field)) unless rule.send(field).nil?
      end

      # Namespaces
      builder_namespaces(rule.namespaces, atom)

      # Transitions
      rule.links.each do |link|
        atom_link = {:rel => link.rel, :href => link.href, :type => (link.type || 'application/atom+xml')}
        entry.links << ::Atom::Link.new(atom_link) unless atom_link[:href].nil?
      end

      # Entries
      options.delete(:values)
      member_options = options.merge(rule.members_options || {})
      objects.each do |member|
        feed.entries << builder_entry(member, rule.members_blocks || [], member_options)
      end
    end
  end

  def builder_entry(object, rules_blocks, options = {})
    rule = Restfulie::Builder::MemberRule.new(rules_blocks)
    options = eagerload_enhance(options)
    
    rule.blocks.unshift(default_member_rule) if options[:default_rule]
    rule.metaclass.send(:attr_accessor, *ATOM_ATTRIBUTES_ENTRY)
    rule.apply(object, options)

    atom = ::Atom::Entry.new do |entry|
      # Set values
      (ATOM_ATTRIBUTES_ENTRY - [:links]).each do
        |field| entry.send("#{field}=".to_sym, rule.send(field)) unless rule.send(field).nil?
      end

      # Namespaces
      builder_namespaces(rule.namespaces, entry)

      # Transitions
      rule.links.each do |link|
        atom_link = {:rel => link.rel, :href => link.href, :type => link.type}

        # Self
        if link.href.nil?
          if link.rel == "self"
            path = object
          else
            association = object.class.reflect_on_all_associations.find { |a| a.name.to_s == link.rel }
            path = (association.macro == :has_many) ? [object, association.name] : object.send(association.name) unless association.nil? 
          end
          atom_link[:href] = polymorphic_url(path, :host => host) rescue nil
          atom_link[:type] = link.type || 'application/atom+xml'
        elsif
          atom_link[:href] = link.href
        end
        
        entry.links << ::Atom::Link.new(atom_link) unless atom_link[:href].nil?
      end
    end
  end

  # TODO: Validate of the required fields
  def default_collection_rule
    Proc.new do |collection_rule, objects, options|
      # Passed values
      (options[:values] || {}).each { |key, value| collection_rule.send("#{key}=".to_sym, value)}
      
      # Default values
      collection_rule.id        ||= options[:self]
      collection_rule.title     ||= "#{objects.first.class.to_s.pluralize.demodulize} feed"
      collection_rule.updated   ||= updated_collection(objects)

      # Transitions
      collection_rule.links << link(:rel => :self, :href => options[:self]) unless options[:self].nil?
    end
  end
  
  def default_member_rule
    Proc.new do |member_rule, object, options|
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

      # Transitions
      if options[:eagerload].include?(:transitions)
        member_rule.links << link(:self)

        object.class.reflect_on_all_associations.map do |association|
          member_rule.links << link(association.name)
        end
      end
    end
  end
  
  def updated_collection(objects)
    objects.map { |item| item.updated_at if item.respond_to?(:updated_at) }.compact.max || Time.now
  end

  def builder_namespaces(namespaces, atom)
    namespaces.each do |ns|
      register_namespace(ns.namespace, ns.uri)
      ns.each do |key, value|
        register_element(ns.namespace, key)
        atom.send("#{ns.namespace}_#{key}=".to_sym, value)
      end
    end
  end

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
  
  def eagerload_enhance(options)
    if options[:eagerload] == true
      options[:eagerload] = [:values, :transitions]
    elsif options[:eagerload] == false
      options[:eagerload] = []
    end
    return options
  end
end