module Restfulie
  module Common
    module Representation
      module Atom
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
      end
    end
  end
end
