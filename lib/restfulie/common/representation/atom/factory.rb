module Restfulie
  module Common
    module Representation
      module Atom
        # Create a new Representation::Atom object using a +string_or_io+
        # object.
        #
        # Examples
        #   xml  = IO.read("spec/units/lib/atoms/full_atom.xml")
        #   atom = Restfulie::Common::Representation::Atom.new(xml)
        class Factory
          # RelaxNG file to validate atom
          RELAXNG_ATOM = File.join(File.dirname(__FILE__), 'atom.rng')

          if Nokogiri::VERSION_INFO["libxml"]["loaded"] < "2.7.7"
            puts "WARNING! In order to use schema validation on atom representations you need libxml version 2.7.7 or superior loaded in your system." 
            SCHEMA       = nil
          else
            SCHEMA       = ::Nokogiri::XML::RelaxNG(File.open(RELAXNG_ATOM))
          end
      
          def self.create(string_or_io)
            doc = string_or_io.kind_of?(Nokogiri::XML::Document) ? string_or_io : Nokogiri::XML(string_or_io) 
            
            if SCHEMA && !(errors = SCHEMA.validate(doc)).empty?
              raise AtomInvalid.new("Invalid Atom: "+ errors.join(", "))
            end
            
            case doc.root.name
            when "feed"
              Restfulie::Common::Representation::Atom::Feed.new(doc)
            when "entry"
              Restfulie::Common::Representation::Atom::Entry.new(doc)
            end        
          end      
        end
        
        class AtomInvalid < StandardError
        end
      end
    end
  end
end
