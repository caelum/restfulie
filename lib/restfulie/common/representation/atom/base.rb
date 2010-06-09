module Restfulie
  module Common
    module Representation
      module Atom
        class Base < XML
          ATOM_ATTRIBUTES = {
            :feed  => {
              :required    => [:id, :title, :updated],
              :recommended => [:author, :link],
              :optional    => [:category, :contributor, :rights, :generator, :icon, :logo, :subtitle]
            },
          
            :entry => {
              :required    => [:id, :title, :updated],
              :recommended => [:author, :link, :content, :summary],
              :optional    => [:category, :contributor, :rights, :published, :source]
            }
          }
          
          def initialize(xml_obj = nil)
            @authors = nil
            @contributors = nil
            @links = nil
            @categories = nil
            @reserved = []
            super(xml_obj)
          end
          
          # lists all extension points available in this entry
          def extensions
            result = []
            @doc.children.each do |e|
              if e.element?
                result << e unless @reserved.map(&:to_s).include?(e.node_name)
              end
            end
            return result
          end
          
          # simpletext
          def id
            text("id")
          end
      
          def id=(value)
            set_text("id", value)
          end
      
          # text
          def title
            text("title")
          end
        
          def title=(value)
            set_text("title", value)
          end
      
          def updated
            value = text("updated")
            Time.parse(value) unless value.nil?
          end
        
          def updated=(value)
            set_text("updated", value)
          end
      
          # text
          def rights
            text("rights")
          end
      
          def rights=(value)
            set_text("rights", value)
          end
        
          # Author have name, and optional uri and email, this describes a person
          def authors
            unless @authors
              @authors = TagCollection.new(@doc)
              @doc.xpath("xmlns:author").each do |author|
                @authors << Person.new("author", author)
              end
            end
            
            return @authors
          end
        
          def contributors
            unless @contributors
              @contributors = TagCollection.new(@doc)
              @doc.xpath("xmlns:author").each do |contributor|
                @contributors << Person.new("contributor", contributor)
              end
            end
            
            return @contributor
          end
        
          # It has one required attribute, href, and five optional attributes: rel, type, hreflang, title, and length
          def links
            unless @links
              @links = TagCollection.new(@doc) do |array, symbol, *args|
                linkset = array.select {|link| link.rel == symbol.to_s }
                unless linkset.empty?
                  linkset.size == 1 ? linkset.first : linkset
                else
                  nil
                end          
              end
              @doc.xpath("xmlns:link").each do |link|
                @links << Link.new(link.attributes)
              end        
            end
            
            return @links
          end
        
          def categories
            unless @categories
              @categories = TagCollection.new(@doc)
              @doc.xpath("xmlns:category").each do |category|
                @categories << Link.new(category)
              end        
            end
            
            return @categories
          end
        end
      end
    end
  end
end
