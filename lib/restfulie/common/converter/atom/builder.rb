module Restfulie::Common::Converter::Atom
  class Builder
    attr_accessor :atom_type

    def initialize(atom_type)
      @doc    = Nokogiri::XML::Document.new
      @parent = @doc.create_element(atom_type.to_s)
      @parent["xmlns"] = "http://www.w3.org/2005/Atom"
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

    def insert_value(name, prefix, *args, &block)
      node = create_element(name.to_s, prefix, *args)
      node.parent = @parent
      
      if block_given?
        @parent = node
        block.call
        @parent = node.parent
      end
    end

    def representation
      Restfulie::Common::Representation::Atom.new(@doc)
    end
    
  private
  
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
      #TODO: raise ArgumentError, "Namespace #{prefix} has not been defined" if wanted
    end
    
  end

end
