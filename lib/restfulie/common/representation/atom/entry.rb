module Restfulie::Common::Representation::Atom
  
  class Entry < Base   
    
    def initialize(xml_obj)
      @source = nil
      super(xml_obj)
    end
     
    #text
    def content
      text("content")
    end

    def content=(value)
      set_text("content", value)
    end
  
    #text
    def summary
      text("summary")
    end

    def summary=(value)
      set_text("summary", value)
    end
  
    #rfc 3339
    def published
      value = text("published")
      Time.parse(value) unless value.nil?
    end

    def published=(value)
      set_text("published", value)
    end
  
    # comp: id, title, udpated, rights (optional)
    def source
      unless @source
        @doc.xpath("xmlns:source").each do |source|
          @source = Generator.new(source)
        end 
      end
      
      return source
    end
    
    def source=(obj)
      @source = obj
    end
  end
  
  class Source < XML    
    def initialize(options_or_obj)
      if options_or_obj.kind_of?(Hash)
        @doc = Nokogiri::XML::Document.new()
        node = @doc.create_element("source")
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
  end
end

