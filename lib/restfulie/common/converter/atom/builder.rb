module Restfulie::Common::Converter::Atom
  class Builder
    attr_accessor :atom_type

    def initialize(atom_type)
      @doc    = Nokogiri::XML::Document.new
      @parent = @doc.create_element(atom_type.to_s)
      @parent["xmlns"] = "http://www.w3.org/2005/Atom"
      @parent.parent = @doc

      # This restriction is needed to allow Nokogiri Builder to create tags such as <id> or <class> without using the underscore flag 
      # Reserved words: insert, to_xml, [], method_missing, respond_to? or any starting with __ 
      Nokogiri::XML::Builder.instance_methods.each do |m|
        Nokogiri::XML::Builder.send(:undef_method, m) unless m.to_s =~ /insert|to_xml|\[\]|method_missing|respond_to\?|^__/
      end
    end

    def values(&block)
      Nokogiri::XML::Builder.with(@parent, &block)
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

    def representation
      Restfulie::Common::Representation::Atom.new(@doc)
    end
  end

end
