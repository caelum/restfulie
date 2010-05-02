# support xml serialization for custom attributes
module Restfulie::Common::Builder::Rules::CustomAttributes
  
  def to_xml(writer)
    custom_attributes.each do |key, value|
      writer.tag!(key, value)
    end
  end
  
end

module Restfulie::Common::Builder::Marshalling::Xml
end

# Xml collection rule answering to to_xml and allowing any custom element to be inserted
# All links will be automatically inserted.
class Restfulie::Common::Builder::Marshalling::Xml::CollectionRule < Restfulie::Common::Builder::CollectionRule
  
  include Restfulie::Common::Builder::Rules::CustomAttributes

  def to_xml(writer)
    super(writer)
    links.each do |link|
      writer.link(:rel => link.rel, :href => link.href, :type => (link.type || 'application/xml')) if link.href
    end
  end

end

# Xml member rule answering to to_xml and allowing any custom element to be inserted.
# All links will be automatically inserted.
class Restfulie::Common::Builder::Marshalling::Xml::MemberRule < Restfulie::Common::Builder::MemberRule

  include ActionController::UrlWriter
  include Restfulie::Common::Builder::Rules::CustomAttributes

  def to_xml(object, writer)
    super(writer)
    # Transitions
    links.each do |link|
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
        atom_link[:type] = link.type || 'application/xml'
      end
      writer.link(:rel => atom_link[:rel], :href => atom_link[:href], :type => (link.type || 'application/xml')) if atom_link[:href]

    end
  end

  private
  def host
    # TODO: If we split restfulie into 2 separate gems, we may need not to use Restfulie::Server
    #       inside Restfulie::Common
    Restfulie::Server::Configuration.host
  end

end

class Restfulie::Common::Builder::Marshalling::Xml::Marshaller < Restfulie::Common::Builder::Marshalling::Base
  include ActionController::UrlWriter
  include Restfulie::Common::Builder::Helpers
  include Restfulie::Common::Error
  
  def initialize(object, rules)
    @object = object
    @rules   = rules
  end

  def builder_collection(options = {})
    builder_feed(@object, @rules, options)
  end

  def builder_member(options = {})
    options[:indent]   ||= 2
    options[:builder]  ||= Builder::XmlMarkup.new(:indent => options[:indent])
    options[:skip_types] = true
    builder_entry(@object, options[:builder], @object.class.name.underscore, @rules, options)
  end

private

  def builder_feed(objects, rules_blocks, options = {})
    rule = Restfulie::Common::Builder::Marshalling::Xml::CollectionRule.new(rules_blocks)

    rule.blocks.unshift(default_collection_rule) if options[:default_rule]
    rule.apply(objects, options)
    
    # setup code from Rails to_xml

     options[:root]     ||= objects.all? { |e| e.is_a?(objects.first.class) && objects.first.class.to_s != "Hash" } ? objects.first.class.to_s.underscore.pluralize : "records"
     options[:children] ||= options[:root].singularize
     options[:indent]   ||= 2
     options[:builder]  ||= Builder::XmlMarkup.new(:indent => options[:indent])

     root     = options.delete(:root).to_s
     children = options.delete(:children)

     if !options.has_key?(:dasherize) || options[:dasherize]
       root = root.dasherize
     end

     options[:builder].instruct! unless options.delete(:skip_instruct)

     opts = options.merge({ :root => children })

     writer = options[:builder]

     # Entries
     options.delete(:values)
     member_options = options.merge(rule.members_options || {})
     member_options[:skip_instruct] = true
     start_with_namespace(rule.namespaces, writer, root, options[:skip_types] ? {} : {}) do
       rule.to_xml(writer)
       yield writer if block_given?
       
       objects.each { |e| 
         builder_entry(e, writer, children, rule.members_blocks || [], member_options)
       }
     end
     
  end
  
  def start_with_namespace(namespaces, writer, root, condition, &block)
    spaces = condition.dup
    namespaces.each do |ns|
      ns.each do |key, value|
        spaces["xmlns:#{ns.namespace}"] = ns.uri
      end if ns.uri
    end
    result = writer.tag!(root, spaces) do |inner|
      namespaces.each do |ns|
        ns.each do |key, value|
          tag = ns.namespace ? "#{key}" : "#{ns.namespace}:#{key}"
          inner.tag! tag, value
        end
      end
      block.call inner
    end
  end
  
  def default_collection_rule
    Proc.new do |collection_rule, objects, options|
    end
  end
  
  def builder_entry(object, xml, children, rules_blocks, options)
    rule    = Restfulie::Common::Builder::Marshalling::Xml::MemberRule.new(rules_blocks)
    options = namespace_enhance(options)

    rule.blocks.unshift(default_member_rule) if options[:default_rule]
    rule.apply(object, options)
    
    start_with_namespace(rule.namespaces, xml, children, {}) do |inner_xml|
      rule.to_xml(object, inner_xml)
    end
  end

  def default_member_rule
    Proc.new do |member_rule, object, options|
      if options[:namespace]
        member_rule.namespace(object, options[:namespace][:uri], options[:namespace])
      else
        member_rule.namespace(object, nil, options[:namespace] || {})
      end
    end
  end

  def namespace_enhance(options)
    if !options[:namespace].nil? && options[:namespace].kind_of?(String)
      options[:namespace] = { :uri => options[:namespace], :eager_load => true }
    end
    options
  end
end
