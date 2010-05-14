require 'nokogiri'

#initialize namespace
module Restfulie::Common::Representation
  # Create a new Representation::Atom object using a +string_or_io+
  # object.
  #
  # Examples
  #   xml  = IO.read("spec/units/lib/atoms/full_atom.xml")
  #   atom = Restfulie::Common::Representation::Atom.new(xml)
  class Atom
    # RelaxNG file to validate atom
    RELAXNG_ATOM = File.join(File.dirname(__FILE__), 'atom', 'atom.rng')
    SCHEMA       = ::Nokogiri::XML::RelaxNG(File.open(RELAXNG_ATOM))

    ATOM_ATTRIBUTES = {
      :entry => {
        :required    => [:id, :title, :updated],
        :recommended => [:author, :link, :content, :summary],
        :optional    => [:category, :contributor, :rights, :published, :source]
      },

      :feed  => {
        :required    => [:id, :title, :updated],
        :recommended => [:author, :link],
        :optional    => [:category, :contributor, :rights, :generator, :icon, :logo, :subtitle]
      }
    
    }

    attr_accessor :doc

    def initialize(string_or_io)
      @doc = string_or_io.kind_of?(Nokogiri::XML::Document) ? string_or_io : Nokogiri::XML(string_or_io) 
    end
    
    # Sugar access
    def id
      css_in_root("id").inner_text
    end

    def title
      css_in_root("title").inner_text
    end

    def updated
      updated = css_in_root("updated").inner_text
      updated.nil? ? nil : Time.parse(updated)
    end
    
    # Author have name, and optional uri and email, this describes a person
    def authors
      authors = css_in_root("author")
      authors.empty? ? [] : authors.map do |author|
        Hash.from_xml(author.to_xml).with_indifferent_access["author"].extend(HashKeyMethodAccess)
      end
    end
      
    # Tools
    def css(*args)
      @doc.css(*args)
    end

    def atom_type
      @doc.root.name
    end

    def valid?
      (@errors = SCHEMA.validate(@doc)).empty?
    end

    def errors
      @errors || nil
    end

    def to_xml
      @doc.to_xml
    end
    
    def to_s
      to_xml
    end
    
  private
  
     def css_in_root(rules)
       css("#{atom_type} > #{rules}")
     end
  end
  
  module HashKeyMethodAccess
    def method_missing(symbol, *args, &block)
      name = symbol.to_s
      if name =~ /=$/
        self[name.chop] = args[0]
      elsif !block_given?
        self[name]
      end
    end
  end
end
