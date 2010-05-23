module Restfulie::Common::Representation::Atom
  
  class XML
    XHTML_LAT1   = File.join(File.dirname(__FILE__), 'xhtml-lat1.ent')
    
    attr_accessor :doc
  
    def initialize(xml_obj = nil)
      if xml_obj
        xml_obj.kind_of?(Nokogiri::XML::Document) ? @doc = xml_obj.root : @doc = xml_obj
      else
        @doc    = Nokogiri::XML::Document.new
        root_node = @doc.create_element(atom_type.to_s)
        root_node.add_namespace_definition(nil, "http://www.w3.org/2005/Atom")
        root_node.parent = @doc
        @doc = @doc.root
      end
    end
    
    # Tools
    def css(*args)
      @doc.css(*args)
    end
  
    def xpath(*args)
      @doc.xpath(*args)
    end

    def atom_type
      self.class.name.demodulize.downcase
    end

    def to_xml
      @doc.to_xml
    end
  
    def to_s
      to_xml
    end
    
  protected 

    def text(node_name)
      (node = @doc.at_xpath("xmlns:#{node_name}")) ? node.content : nil
    end

    def set_text(node_name, value)
      unless (node = @doc.at_xpath("xmlns:#{node_name}"))
        node = create_element(node_name, value)
        node.parent = @doc
      else
        value = value.xmlschema if value.kind_of?(Time) || value.kind_of?(DateTime)
        node.content = value
      end
    end

  private

    def create_element(node, *args)
      node = @doc.document.create_element(node) do |n|
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
    
  end
  
  
  class Base < XML
  
    ATOM_ATTRIBUTES = {
      :feed  => {
        :required    => [:id, :title, :updated],
        :recommended => [:author, :link],
        :optional    => [:category, :contributor, :rights, :generator, :icon, :logo, :subtitle]
      },
    
      :entry => {
        :required    => [:id, :title, :updated],
        :recommended => [:author, :link, :content, :summary],
        :optional    => [:category, :contributor, :rights, :published, :source]
      }
    }
    
    def initialize(xml_obj = nil)
      @authors = nil
      @contributors = nil
      @links = nil
      @categories = nil
      @reserved = []
      super(xml_obj)
    end
    
    # lists all extension points available in this entry
    def extensions
      result = []
      @doc.children.each do |e|
        if e.element?
          result << e unless @reserved.map(&:to_s).include?(e.node_name)
        end
      end
      return result
    end
    
    #simpletext
    def id
      text("id")
    end

    def id=(value)
      set_text("id", value)
    end

    # text
    def title
      text("title")
    end
  
    def title=(value)
      set_text("title", value)
    end

    def updated
      value = text("updated")
      Time.parse(value) unless value.nil?
    end
  
    def updated=(value)
      set_text("updated", value)
    end

    # text
    def rights
      text("rights")
    end

    def rights=(value)
      set_text("rights", value)
    end
  
    # Author have name, and optional uri and email, this describes a person
    def authors
      unless @authors
        @authors = TagCollection.new(@doc)
        @doc.xpath("xmlns:author").each do |author|
          @authors << Person.new("author", author)
        end
      end
      
      return @authors
    end
  
    def contributors
      unless @contributors
        @contributors = TagCollection.new(@doc)
        @doc.xpath("xmlns:author").each do |contributor|
          @contributors << Person.new("contributor", contributor)
        end
      end
      
      return @contributor
    end
  
    # It has one required attribute, href, and five optional attributes: rel, type, hreflang, title, and length
    def links
      unless @links
        @links = TagCollection.new(@doc) do |array, symbol, *args|
          linkset = array.select {|link| link.rel == symbol.to_s }
          unless linkset.empty?
            linkset.size == 1 ? linkset.first : linkset
          else
            nil
          end          
        end
        @doc.xpath("xmlns:link").each do |link|
          @links << Link.new(link)
        end        
      end
      
      return @links
    end
  
    def categories
      unless @categories
        @categories = TagCollection.new(@doc)
        @doc.xpath("xmlns:category").each do |category|
          @categories << Link.new(category)
        end        
      end
      
      return @categories
    end
  end

  class TagCollection < ::Array
    def initialize(parent_node, &block)
      @node = parent_node
      @method_missing_block = block_given? ? block : nil
      super(0)
    end
    
    def <<(obj)
      obj = [obj] unless obj.kind_of?(Array)
      obj.each do |o|
        o.doc.parent = @node
        super(o)
      end
    end
    
    def delete(obj)
      if super(obj)
        obj.doc.unlink
        obj = nil
      end
    end
    
    def method_missing(symbol, *args, &block)
      if @method_missing_block
        @method_missing_block.call(self, symbol, *args)
      else
        super
      end
    end
  end

  class Link < XML    
    def initialize(options_or_obj)
      if options_or_obj.kind_of?(Hash)
        @doc = Nokogiri::XML::Document.new()
        options_or_obj = create_element("link", options_or_obj)
      end
      super(options_or_obj)
    end
    
    def href
      @doc["href"]
    end
    
    def href=(value)
      @doc["href"] = value
    end
    
    def rel
      @doc["rel"]
    end
    
    def rel=(value)
      @doc["rel"] = value
    end

    alias_method :__type__, :type
    def type
      @doc["type"]
    end
    
    def type=(value)
      @doc["type"] = value
    end

    def hreflang
      @doc["hreflang"]
    end
    
    def hreflang=(value)
      @doc["hreflang"] = value
    end

    def title
      @doc["title"]
    end
    
    def title=(value)
      @doc["title"] = value
    end
    
    def length
      @doc["length"]
    end
    
    def length=(value)
      @doc["length"] = value
    end
  end
  
  class Person < XML    
    def initialize(node_type, options_or_obj)
      if options_or_obj.kind_of?(Hash)
        @doc = Nokogiri::XML::Document.new()
        node = @doc.create_element(node_type)
        node.add_namespace_definition(nil, "http://www.w3.org/2005/Atom")
        node.parent = @doc
        super(node)
        options_or_obj.each do |key,value|
          self.send("#{key}=".to_sym, value)
        end
      else
        super(options_or_obj)
      end
    end
    
    def name
      text("name")
    end
    
    def name=(value)
      set_text("name", value)
    end
    
    def uri
      text("uri")
    end
    
    def uri=(value)
      set_text("uri", value)
    end

    def email
      text("email")
    end
    
    def email=(value)
      set_text("email", value)
    end
  end
  
  class Category < XML    
    def initialize(options_or_obj)
      if options_or_obj.kind_of?(Hash)
        @doc = Nokogiri::XML::Document.new()
        options_or_obj = create_element("category", options_or_obj)
      end
      super(options_or_obj)
    end
    
    def term
      @doc["term"]
    end
    
    def term=(value)
      @doc["term"] = value
    end
    
    def scheme
      @doc["scheme"]
    end
    
    def scheme=(value)
      @doc["scheme"] = value
    end

    def label
      @doc["label"]
    end
    
    def label=(value)
      @doc["label"] = value
    end
  end

end