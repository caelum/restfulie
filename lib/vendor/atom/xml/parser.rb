# Copyright (c) 2008 The Kaphan Foundation
#
# For licensing information see LICENSE.txt.
#
# Please visit http://www.peerworks.org/contact for further information.
#
require 'net/http'
require 'time'

# Just a couple methods form transforming strings
unless defined?(ActiveSupport)
  class String # :nodoc:
    def singularize
      if self =~ /ies$/
        self.sub(/ies$/, 'y')
      else
        self.sub(/s$/, '')
      end
    end
  
    def demodulize
      self.sub(/.*::/, '')
    end
    
    def constantize
      Object.module_eval("::#{self}", __FILE__, __LINE__)
    end
  end
end

module Atom
  class LoadError < StandardError
    attr_reader :response
    def initialize(response)
      @response = response
    end
    
    def to_s
      "Atom::LoadError: #{response.code} #{response.message}"
    end
  end
  
  module Xml # :nodoc:
   class NamespaceMap
      def initialize(default = Atom::NAMESPACE)
        @default = default
        @i = 0
        @map = {}
      end
      
      def prefix(ns, element)
        if ns == @default
          element
        else
          "#{get(ns)}:#{element}"
        end
      end
      
      def get(ns)
        if ns == Atom::NAMESPACE
          @map[ns] = "atom"
        elsif ns == Atom::Pub::NAMESPACE
          @map[ns] = "app"
        else
          @map[ns] or @map[ns] = "ns#{@i += 1}"
        end
      end
      
      def each(&block)
        @map.each(&block)
      end
    end
    
    module Parseable # :nodoc:
      def parse(xml, options = {})
        starting_depth = xml.depth
        loop do
          case xml.node_type
          when XML::Reader::TYPE_ELEMENT
            if element_specs.include?(xml.local_name) && (self.class.known_namespaces + [Atom::NAMESPACE, Atom::Pub::NAMESPACE]).include?(xml.namespace_uri)
              element_specs[xml.local_name].parse(self, xml)
            elsif attributes.any?
              while (xml.move_to_next_attribute == 1)
                if attributes.include?(xml.name)
                  # Support attribute names with namespace prefixes
                  self.send("#{xml.name.sub(/:/, '_')}=", xml.value)
                elsif self.respond_to?(:simple_extensions)
                  self[xml.namespace_uri, xml.local_name].as_attribute = true
                  self[xml.namespace_uri, xml.local_name] << xml.value
                end
              end
            elsif self.respond_to?(:simple_extensions)
              self[xml.namespace_uri, xml.local_name] << xml.read_inner_xml
            end
          end
          break unless !options[:once] && xml.next == 1 && xml.depth >= starting_depth
        end
      end
    
      def next_node_is?(xml, element, ns = nil)
        # Get to the next element
        while xml.next == 1 && xml.node_type != XML::Reader::TYPE_ELEMENT; end
        current_node_is?(xml, element, ns)
      end
      
      def current_node_is?(xml, element, ns = nil)
        xml.node_type == XML::Reader::TYPE_ELEMENT && xml.local_name == element && (ns.nil? || ns == xml.namespace_uri)
      end
  
      def Parseable.included(o)
        o.class_eval do
          def o.ordered_element_specs;  @ordered_element_specs ||= []; end
          def o.element_specs;  @element_specs ||= {}; end
          def o.attributes; @attributes ||= []; end
          def element_specs; self.class.element_specs; end
          def ordered_element_specs; self.class.ordered_element_specs; end
          def attributes; self.class.attributes; end
          def o.namespace(ns = @namespace); @namespace = ns; end
          def o.add_extension_namespace(ns, url); self.extensions_namespaces[ns.to_s] = url; end
          def o.extensions_namespaces; @extensions_namespaces ||= {} end
          def o.known_namespaces; @known_namespaces ||= [] end
        end
        o.send(:extend, DeclarationMethods)
      end
      
      def ==(o)
        if self.object_id == o.object_id
          true
        elsif o.instance_of?(self.class)
          self.class.element_specs.values.all? do |spec|
            self.send(spec.attribute) == o.send(spec.attribute)
          end
        else
          false
        end
      end
      
      # There doesn't seem to be a way to set namespaces using libxml-ruby,
      # so ratom has to manage namespace to URI prefixing itself, which
      # makes this method more complicated that it needs to be.
      #
      def to_xml(nodeonly = false, root_name = self.class.name.demodulize.downcase, namespace = nil, namespace_map = nil)
        namespace_map = NamespaceMap.new(self.class.namespace) if namespace_map.nil?
        node = XML::Node.new(root_name)
        node['xmlns'] = self.class.namespace unless nodeonly || !self.class.respond_to?(:namespace)
        self.class.extensions_namespaces.each do |ns_alias,uri|
          node["xmlns:#{ns_alias}"] = uri
        end

        self.class.ordered_element_specs.each do |spec|
          if spec.single?
            if attribute = self.send(spec.attribute)
              if attribute.respond_to?(:to_xml)
                node << attribute.to_xml(true, spec.name, spec.options[:namespace], namespace_map)
              else
                n =  XML::Node.new(spec.name)
                n['xmlns'] = spec.options[:namespace] if spec.options[:namespace]
                n << (attribute.is_a?(Time)? attribute.xmlschema : attribute.to_s)
                node << n
              end
            end
          else
            value = self.send(spec.attribute)
            if (value.respond_to?(:each))
              value.each do |attribute|
                if attribute.respond_to?(:to_xml)
                  node << attribute.to_xml(true, spec.name.singularize, nil, namespace_map)
                else
                  n = XML::Node.new(spec.name.singularize)
                  n['xmlns'] = spec.options[:namespace] if spec.options[:namespace]
                  n << attribute.to_s
                  node << n
                end
              end
            end
          end
        end
        
        self.class.attributes.each do |attribute|
          if value = self.send("#{attribute.sub(/:/, '_')}")
            if value != 0
              node[attribute] = value.to_s
            end
          end
        end
        
        if self.respond_to?(:simple_extensions) && self.simple_extensions
          self.simple_extensions.each do |name, value_array|
            if name =~ /\{(.*),(.*)\}/
              value_array.each do |value|
                if value_array.as_attribute
                  node["#{namespace_map.get($1)}:#{$2}"] = value
                else
                  ext = XML::Node.new("#{namespace_map.get($1)}:#{$2}")
                  ext << value
                  node << ext
                end
              end
            else
              STDERR.print "Couldn't split #{name}"
            end
          end
        end
        
        unless nodeonly
          namespace_map.each do |ns, prefix|
            node["xmlns:#{prefix}"] = ns
          end
          
          doc = XML::Document.new
          doc.root = node
          doc.to_s
        else
          node
        end
      end
    
      module DeclarationMethods # :nodoc:
        def element(*names)
          options = {:type => :single}
          options.merge!(names.pop) if names.last.is_a?(Hash) 
        
          names.each do |name|
            attr_accessor name.to_s.sub(/:/, '_').to_sym
            ns, local_name = name.to_s[/(.*):(.*)/,1], $2 || name
            self.known_namespaces << self.extensions_namespaces[ns] if ns
            self.ordered_element_specs << self.element_specs[local_name.to_s] = ParseSpec.new(name, options)
          end
        end
            
        def elements(*names)
          options = {:type => :collection}
          options.merge!(names.pop) if names.last.is_a?(Hash)
        
          names.each do |name|
            name_sym = name.to_s.sub(/:/, '_').to_sym
            attr_writer name_sym
            define_method name_sym do 
              ivar = :"@#{name_sym}"
              self.instance_variable_set ivar, [] unless self.instance_variable_defined? ivar
              self.instance_variable_get ivar
            end
            ns, local_name = name.to_s[/(.*):(.*)/,1], $2 || name
            self.known_namespaces << self.extensions_namespaces[ns] if ns
            self.ordered_element_specs << self.element_specs[local_name.to_s.singularize] = ParseSpec.new(name, options)
          end
        end
      
        def attribute(*names)
          names.each do |name|
            attr_accessor name.to_s.sub(/:/, '_').to_sym
            self.attributes << name.to_s
          end
        end
      
        def loadable!(&error_handler)
          class_name = self.name
          (class << self; self; end).instance_eval do
            
            define_method "load_#{class_name.demodulize.downcase}" do |*args|
               o = args.first
               opts = args.size > 1 ? args.last : {}
               
               xml = 
                case o
                when String
                  XML::Reader.string(o)
                when IO
                  XML::Reader.io(o)
                when URI
                  raise ArgumentError, "#{class_name}.load only handles http URIs" if o.scheme != 'http'
                  response = nil
                  Net::HTTP.start(o.host, o.port) do |http|
                    request = Net::HTTP::Get.new(o.request_uri)
                    if opts[:user] && opts[:pass]
                      request.basic_auth(opts[:user], opts[:pass])
                    elsif opts[:hmac_access_id] && opts[:hmac_secret_key]
                      if Atom::Configuration.auth_hmac_enabled?
                        AuthHMAC.sign!(request, opts[:hmac_access_id], opts[:hmac_secret_key])
                      else
                        raise ArgumentError, "AuthHMAC credentials provides by auth-hmac gem is not installed"
                      end
                    end
                    response = http.request(request)
                  end
                  case response
                  when Net::HTTPSuccess
                    XML::Reader.string(response.body)
                  when nil
                    raise ArgumentError.new("nil response to #{o}")
                  else
                    raise Atom::LoadError.new(response)
                  end
                else
                  raise ArgumentError, "#{class_name}.load needs String, URI or IO, got #{o.class.name}"
                end

                if error_handler
                  XML::Error.set_handler(&error_handler)
                else
                  XML::Error.set_handler do |reader, message, severity, base, line|
                    if severity == XML::Reader::SEVERITY_ERROR
                      raise ArgumentError, "#{message} at #{line} in #{o}"
                    end
                  end
                end
                
                o = self.new(xml)
                xml.close
                o
            end
          end
        end
        
        def parse(xml)
          new(xml)
        end
      end
    
      # Contains the specification for how an element should be parsed.
      #
      # This should not need to be constructed directly, instead use the
      # element and elements macros in the declaration of the class.
      #
      # See Parseable.
      #
      class ParseSpec # :nodoc:
        attr_reader :name, :options, :attribute
      
        def initialize(name, options = {})
          @name = name.to_s
          @attribute = name.to_s.sub(/:/, '_')
          @options = options
        end
      
        # Parses a chunk of XML according the specification.
        # The data extracted will be assigned to the target object.
        #
        def parse(target, xml)
          case options[:type]
          when :single
            target.send("#{@attribute}=".to_sym, build(target, xml))
          when :collection
            collection = target.send(@attribute.to_s)
            element    = build(target, xml)
            collection << element
          end
        end
      
        def single?
          options[:type] == :single
        end
        
        private
        # Create a member 
        def build(target, xml)
          if options[:class].is_a?(Class)
            if options[:content_only]
              options[:class].parse(xml.read_string)
            else
              options[:class].parse(xml)
            end
          elsif options[:type] == :single
            xml.read_string
          elsif options[:content_only] 
            xml.read_string
          else
            target_class = target.class.name
            target_class = target_class.sub(/#{target_class.demodulize}$/, name.singularize.capitalize)
            target_class.constantize.parse(xml)
          end
        end
      end
    end
  end
end
