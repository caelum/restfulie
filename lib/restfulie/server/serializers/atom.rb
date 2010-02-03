module Restfulie
  module Server
    module Serializers
      class Atom
        include ActionController::UrlWriter
        ATTRIBUTES_ALREADY_IN_ATOM_SPEC = [:id, :title, :updated_at, :created_at]

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
            entry.links     << atom_self_link

            entry.links     << atom_associations_links if atom_associations
            
            # TODO: Deal with authors
            # TODO: Deal with content and summary

            # atom_attributes.each do |attribute|
            #             entry.send("#{model}_#{attribute}=", self.send(attribute))
            #           end 
            
            yield entry if block_given?
          end
        end
        
      protected

        def atom_self_link(options={})
          ::Atom::Link.new(:rel => 'self', :href => polymorphic_url(@record, :host => 'localhost:3000'))
        end

        def atom_associations_links(options={})
          atom_associations.map do |association|
            ::Atom::Link.new(:rel => association, :href => polymorphic_url(@record.send(association), :host => 'localhost:3000'))
          end
        end

        def atom_associations
          @record.class.reflect_on_all_associations.map(&:name)
        end

        def atom_attributes
          @record.class.column_names - ATTRIBUTES_ALREADY_IN_ATOM_SPEC
        end
        
        def register_element(attribute)
          ::Atom::Entry.element(namespaced_class_and_attribute(attribute)) if element_unregistered?(namespaced_class_and_attribute(attribute))
        end
        # alias :register_elements :register_element
        
        def element_unregistered?(element)
          ::Atom::Entry.element_specs.select { |k,v|  v.name == element }.nil?
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
   