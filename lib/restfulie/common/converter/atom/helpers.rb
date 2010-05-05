module Restfulie::Common::Converter::Atom

   module Helpers
     
     # Adding namespace in atom feed or entry represenation
     #
     # Examples:
     #
     #   atom = Restfulie::Common::Converter::Atom.to_atom(Object.new) do |rep, obj|
     #      namespace(obj, :object, "http://localhost/objects") do |ns|
     #        ns.description = "Object description"
     #      end
     #   end
     #   
     #   atom.object_description # "Object description"
     def namespace(atom, name, uri, &block)
       ns = Restfulie::Common::Converter::Atom::Namespace.new(name, uri)
       block.call(ns) if block_given?
       map_namespace(atom, ns)
     end

   private

     def map_namespace(atom, namespace)
       klass = atom.class
       register_namespace(namespace.namespace, namespace.uri, klass)
       
       namespace.each do |key, value|
         options = { :type => (value.kind_of?(Array) ? :collection : :single) }
         register_element(namespace.namespace, key, klass, options)
         atom.send("#{namespace.namespace}_#{key}=".to_sym, value)
       end
     end

     def register_namespace(namespace, uri, klass)
       klass.add_extension_namespace(namespace, uri)
     end

     def register_element(namespace, attribute, klass, options = {})
       attribute = "#{namespace}:#{attribute}"
       klass.element(attribute, options) if element_unregistered?(attribute, klass)
     end

     def element_unregistered?(element, klass)
       klass.element_specs.select { |k,v|  v.name == element }.empty?
     end

   end

end
