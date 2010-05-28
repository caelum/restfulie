module Restfulie
  module Common
    module Converter
      module Json
        class Builder
          def initialize(obj, initial_obj = {})
            @doc     = initial_obj
            @obj     = obj
            @current = @doc
          end
      
          def values(options = nil, &block)
            yield Restfulie::Common::Converter::Values.new(self)
          end
          
          def members(options = {}, &block)
            collection = options[:collection] || @obj 
            raise Restfulie::Common::Error::BuilderError.new("Members method require a collection to execute") unless collection.respond_to?(:each)
            raise Restfulie::Common::Error::BuilderError.new("You need to inform the collection root name") unless options[:name]
            
            collection.each do |member|
              node = {}
              
              parent = @current
              @current = node
              block.call(self, member)
              @current = parent
              
              add_to_current(options[:name], node)
            end
          end
          
          def link(relationship, uri, options = {})
            options["rel"] = relationship.to_s
            options["href"] = uri
            options["type"] ||= "application/json"
            insert_value("link", nil, options)
          end
      
          def insert_value(name, prefix, *args, &block)
            node = create_element(block_given?, *args)
            
            if block_given?
              parent = @current
              @current = node
              block.call
              @current = parent
            end
            
            add_to_current(name, node)
          end
      
          def representation
            Restfulie::Common::Representation::Json.create(@doc)
          end
          
        private
        
          def create_element(has_block, *args)
            vals = []
            hashes = []
            
            args.each do |arg|
              arg.kind_of?(Hash) ? hashes << arg : vals << arg
            end
            
            if hashes.empty?
              # only simple values
              unless vals.empty?
                vals = vals.first if vals.size == 1
                node = has_block ? {} : vals
              else
                node = has_block ? {} : nil
              end
            else
              # yes we have hashes
              node = {} 
              hashes.each { |hash| node.merge!(hash) }
              unless vals.empty?
                vals = vals.first if vals.size == 1
                node = has_block ? {} : [node, vals]
              end
              node
            end
          end
          
          def add_to_current(name, value)
            if @current[name]
              if @current[name].kind_of?(Array)
                @current[name] << value
              else
                @current[name] = [@current[name], value]
              end
            else
              @current[name] = value
            end
          end
        end
      end
    end
  end
end
