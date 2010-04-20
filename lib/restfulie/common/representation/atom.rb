require 'nokogiri'
puts "WARNING! You need libxml version 2.7.7 or superior loaded in your system." if Nokogiri::VERSION_INFO["libxml"]["loaded"] < "2.7.7"

#initialize namespace
module Restfulie::Common::Representation::Atom
  # Create a new Representation::Atom object using a +string_or_io+
  # object.
  #
  # Examples
  #   xml  = IO.read("spec/units/lib/atoms/full_atom.xml")
  #   atom = Restfulie::Common::Representation::Atom.new(xml)
  class Factory
    # RelaxNG file to validate atom
    RELAXNG_ATOM = File.join(File.dirname(__FILE__), 'atom', 'atom.rng')
    SCHEMA       = ::Nokogiri::XML::RelaxNG(File.open(RELAXNG_ATOM))

    class << self
      def create(string_or_io)
        doc = string_or_io.kind_of?(Nokogiri::XML::Document) ? string_or_io : Nokogiri::XML(string_or_io) 
        
        unless (errors = SCHEMA.validate(doc)).empty?
          raise Restfulie::Common::Representation::Atom::AtomInvalid.new("Invalid Atom: "+ errors.join(", "))
        end
        
        if doc.root.name == "feed"
          Restfulie::Common::Representation::Atom::Feed.new(doc)
        elsif doc.root.name == "entry"
          Restfulie::Common::Representation::Atom::Entry.new(doc)
        end        
      end      
    end
    
  end
  
  class AtomInvalid < StandardError; end
  
end

%w(
  base
  feed
  entry
).each do |file|
  require File.join(File.dirname(__FILE__), 'atom', file)
end

