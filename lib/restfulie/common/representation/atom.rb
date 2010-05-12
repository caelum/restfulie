require 'nokogiri'

#initialize namespace
module Restfulie::Common::Representation
  # Create a new Representation::Atom object using a +string_or_io+
  # object.
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

    def id
      @doc.xpath("//id").inner_text
    end

    def title
      @doc.xpath("//title").inner_text
    end

    def updated
      updated = @doc.xpath("//updated").inner_text
      updated.nil? ? nil : Time.parse(updated)
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

  end
end

#%w(
  #base
  #feed
  #entry
#).each do |file|
  #require File.join(File.dirname(__FILE__), 'atom', file)
#end
