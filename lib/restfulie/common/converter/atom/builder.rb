module Restfulie::Common::Converter::Atom
  class Builder
    attr_accessor :atom_type

    def initialize(atom_type)
      @doc    = Nokogiri::XML::Document.new
      @parent = @doc.create_element(atom_type.to_s)
      @parent["xmlns"] = "http://www.w3.org/2005/Atom"
      @parent.parent = @doc
    end

    def values(&block)
      yield Restfulie::Common::Converter::Components::Values.new(self)
    end
    
    def members(&block)
      @converter.obj.each do |member|
        entry = @doc.create_element("entry")
        entry.parent = @parent
        @parent = entry
        block.call(self, member)
        @parent = entry.parent
      end
    end
    
    def link
    end

    # TODO: Verificar o nível para feed e entry, trabalhar os atributos reservados
    def insert(node, *args, &block)
      node = @doc.create_element(node.to_s)
      node.parent = @parent
      
      unless block_given?
        value = args.first
        value = value.xmlschema if value.kind_of?(Time) || value.kind_of?(DateTime)
        text = @doc.create_text_node(value)
        text.parent = node
      else
        @parent = node
        block.call
        @parent = node.parent
      end
    end

    def representation
      Restfulie::Common::Representation::Atom.new(@doc)
    end
  end
end
