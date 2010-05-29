module Restfulie
  module Common
    module Converter
      module Xml
        # Implements the interface for marshal Xml media type requests (application/xml)
        class Builder
          attr_reader :doc
          def initialize(obj, options = {})
            @doc    = Nokogiri::XML::Document.new
            @obj    = obj
            root = options[:root] || Restfulie::Common::Converter.root_element_for(obj)
            @parent = @doc.create_element(root)
            @parent.parent = @doc
          end
          
          def values(options = {}, &block)
            options.each do |key,value|
              attr = key.to_s
              if attr =~ /^xmlns(:\w+)?$/
                ns = attr.split(":", 2)[1]
                @parent.add_namespace_definition(ns, value)
              end
            end             
            yield Values.new(self)
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
            options["type"] ||= "application/xml"
            insert_value("link", nil, options)
          end
          
          def members(a_collection = nil, &block)
            collection = a_collection || @obj 
            raise Error::BuilderError("Members method require a collection to execute") unless collection.respond_to?(:each)
            collection.each do |member|
              entry = @doc.create_element(Restfulie::Common::Converter.root_element_for(member))
              entry.parent = @parent
              @parent = entry
              block.call(self, member)
              @parent = entry.parent
            end
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
                  content = if arg.kind_of?(Time) || arg.kind_of?(DateTime)
                      arg.xmlschema
                    else
                      arg
                    end
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
      end
    end
  end
end
