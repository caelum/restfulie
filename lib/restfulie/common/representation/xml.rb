module Restfulie::Common::Converter
end
module Restfulie::Common::Converter::Xml
end

class Hash
  def links(*args)
    links = fetch("link", [])
    Restfulie::Common::Converter::Xml::Links.new(links)
  end
  def method_missing(sym, *args)
    self[sym.to_s].nil? ? super(sym, args) : self[sym.to_s]
  end
  def respond_to?(sym)
    include?(sym.to_s) || super(sym)
  end
end

class Restfulie::Common::Converter::Xml::Links
  def initialize(links)
    links = [links] unless links.kind_of? Array
    links = [] unless links
    @links = links.map do |l|
      Restfulie::Common::Converter::Xml::Link.new(l)
    end
  end
  def method_missing(sym, *args)
    @links.find do |link|
      link.rel == sym.to_s
    end
  end
end

class Restfulie::Common::Converter::Xml::Link
  # include ::Restfulie::Client::HTTP::LinkRequestBuilder

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

# Implements the interface for marshal Xml media type requests (application/xml)
module Restfulie::Common::Converter::Xml

    mattr_reader :media_type_name
    @@media_type_name = 'application/xml'

    mattr_reader :headers
    @@headers = { 
      :post => { 'Content-Type' => media_type_name }
    }

    # def marshal(entity, rel)
    #   return entity if entity.kind_of? String
    #   return entity.values.first.to_xml(:root => entity.keys.first) if entity.kind_of?(Hash) && entity.size==1
    #   entity.to_xml
    # end
    # 

    mattr_reader :recipes
    @@recipes = {}

    def self.describe_recipe(recipe_name, options={}, &block)
      raise 'Undefined recipe' unless block_given?
      raise 'Undefined recipe_name'   unless recipe_name
      @@recipes[recipe_name] = block
    end

    def self.to_xml(obj, options = {}, &block)
      return obj if obj.kind_of?(String)
      
      if block_given?
        recipe = block 
      elsif options[:recipe]
        recipe = @@recipes[options[:recipe]]
      else
        recipe = lambda { |what|
          debugger
          puts "what"
        }
      end
      
      # Create representation and proxy
      builder = Builder.new(obj)

      # Check recipe arity size before calling it
      recipe.call(*[builder, obj, options][0,recipe.arity])
      puts builder.doc.to_xml
      Hash.from_xml builder.doc.to_xml
    end
    
    def self.helper
      Restfulie::Common::Converter::Xml::Helpers
    end

end
class Restfulie::Common::Converter::Xml::Builder
  attr_reader :doc
  def initialize(obj, options = {})
    @doc    = Nokogiri::XML::Document.new
    @obj    = obj
    if options[:root]
      root = options[:root]
    else
      root = root_element_for(obj)
    end
    @parent = @doc.create_element(root)
    @parent.parent = @doc
  end
  
  def values(options = nil, &block)
    options.each do |key,value|
      attr = key.to_s
      if attr =~ /^xmlns(:\w+)?$/
        ns = attr.split(":", 2)[1]
        @parent.add_namespace_definition(ns, value)
      end
    end if options
    
    yield Restfulie::Common::Converter::Components::Values.new(self)
  end

  def insert_value(name, prefix, *args, &block)
    node = create_element(name.to_s, prefix, *args)
    node.parent = @parent
    
    if block_given?
      @parent = node
      block.call
      @parent = node.parent
    end
  end
  
  def link(relationship, uri, options = {})
    options["rel"] = relationship.to_s
    options["href"] = uri
    insert_value("link", nil, options)
  end
  
  def members(a_collection = nil, &block)
    collection = a_collection || @obj 
    raise Restfulie::Common::Error::BuilderError("Members method require a collection to execute") unless collection.respond_to?(:each)
    collection.each do |member|
      entry = @doc.create_element(root_element_for(member))
      entry.parent = @parent
      @parent = entry
      block.call(self, member)
      @parent = entry.parent
    end
  end
  
  private

  def root_element_for(obj)
    if obj.kind_of?(Hash) && obj.size==1
      obj.keys.first.to_s
    elsif obj.kind_of?(Array) && !obj.empty?
      root_element_for(obj.first).pluralize
    else
      obj.class.to_s
    end
  end
  
  def create_element(node, prefix, *args)
    node = @doc.create_element(node) do |n|
      if prefix
        if namespace = prefix_valid?(prefix)
          # Adding namespace prefix
          n.namespace = namespace
          namespace = nil
        end
      end

      args.each do |arg|
        case arg
        # Adding XML attributes
        when Hash
          arg.each { |k,v|
            key = k.to_s
            if key =~ /^xmlns(:\w+)?$/
              ns_name = key.split(":", 2)[1]
              n.add_namespace_definition(ns_name, v)
              next
            end
            n[k.to_s] = v.to_s
          }
        # Adding XML node content
        else            
          arg.kind_of?(Time) || arg.kind_of?(DateTime) ? content = arg.xmlschema : content = arg
          n.content = content
        end
      end
    end
  end
  
  def prefix_valid?(prefix)
    ns = @parent.namespace_definitions.find { |x| x.prefix == prefix.to_s }
    
    unless ns
      @parent.ancestors.each do |a|
        next if a == @doc
        ns = a.namespace_definitions.find { |x| x.prefix == prefix.to_s }
        break if ns
      end      
    end
    
    return ns
  end
    
end

module Restfulie::Common::Converter::Xml::Helpers
  def collection(obj, *args, &block)
    Restfulie::Common::Converter::Xml.to_xml(obj, {}, &block)
  end

  def member(obj, *args, &block)
    Restfulie::Common::Converter::Xml.to_xml(obj, {}, &block)
  end
end
