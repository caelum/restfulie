module Restfulie
  module Common
    module Representation
      module Atom
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
          
          # simpletext
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
      end
    end
  end
end
