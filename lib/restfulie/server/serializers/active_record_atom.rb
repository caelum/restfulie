module Restfulie
  module Server
    module Serializers
      module ActiveRecord
        class Atom
          include ActionController::UrlWriter
          ATTRIBUTES_ALREADY_IN_ATOM_SPEC = ["id", "title", "updated_at", "created_at"]
        
          attr_reader :record
        
          def initialize(record, options={}, &block)
            @record = record
            register_namespace(namespaced_class)
          end

          def atomify(options={})
          
            ::Atom::Entry.new do |entry|
              entry.id        = @record.id
              entry.title     = "Entry about #{@record.class}"
              entry.published = @record.created_at
              entry.updated   = @record.updated_at
            
              entry.links     << atom_self_link unless options[:skip_self_link]
              entry.links     += atom_associations_links if atom_associations && !options[:skip_associations_links]
            
              # TODO: Deal with authors
              # TODO: Deal with content and summary


              extension_attributes.each do |attribute|
                register_element(attribute)
                entry.send("#{namespaced_class}_#{attribute}=", @record.send(attribute))
              end 
            
              yield entry if block_given?
            end
          end
        
        protected

          def atom_self_link(options={})
            ::Atom::Link.new(:rel => :self, :href => polymorphic_url(@record, :host => 'localhost:3000'))
          end

          def atom_associations_links(options={})
            atom_associations.map do |association|
              if association.macro == :has_many
                ::Atom::Link.new(:rel => association.name, :href => polymorphic_url([@record, association.name], :host => 'localhost:3000'))
              else
                ::Atom::Link.new(:rel => association.name, :href => polymorphic_url(@record.send(association.name), :host => 'localhost:3000'))
              end
            end
          end

          def atom_associations
            @record.class.reflect_on_all_associations
          end

          def extension_attributes
            @record.class.column_names - ATTRIBUTES_ALREADY_IN_ATOM_SPEC
          end
        
          def register_element(attribute)
            ::Atom::Entry.element(namespaced_class_and_attribute(attribute)) if element_unregistered?(namespaced_class_and_attribute(attribute))
          end
        
          def register_elements(attribute)
            ::Atom::Entry.elements(namespaced_class_and_attribute(attribute)) if element_unregistered?(namespaced_class_and_attribute(attribute))
          end
        
          def element_unregistered?(element)
            ::Atom::Entry.element_specs.select { |k,v|  v.name == element }.empty?
          end
        
          def namespaced_class_and_attribute(attribute)
            "#{namespaced_class}:#{attribute}"
          end
        
          def namespaced_class
            @record.class.name.downcase.gsub(/_/, ':')
          end
        
          def register_namespace(namespace)
            ::Atom::Entry.add_extension_namespace(namespace, urn(namespace)) unless ::Atom::Entry.known_namespaces.include? urn(namespace)
          end
        
          def urn(name)
            "urn:#{name}"
          end
        end
      end
    end
  end
end
   