module Restfulie
  module Common
    module Converter
      module Atom
        module Helpers
          def collection(obj, *args, &block)
            Restfulie::Common::Converter::Atom.to_atom(obj, :atom_type => :feed, &block)
          end
      
          def member(obj, *args, &block)
            Restfulie::Common::Converter::Atom.to_atom(obj, :atom_type => :entry, &block)
          end
        end
      end
    end
  end
end
