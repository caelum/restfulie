module Restfulie
  module Common
    module Representation
      class Json
        class LinkCollection
          def initialize(parent_node)
            @node = parent_node
          end
          
          def method_missing(symbol, *args, &block)
            linkset = @node.select {|link| link.rel == symbol.to_s }
            linkset.map! { |link| Link.new(link) }
            unless linkset.empty?
              linkset.size == 1 ? linkset.first : linkset
            else
              nil
            end
          end
        end
      end
    end
  end
end
