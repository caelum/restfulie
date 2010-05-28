module Restfulie::Common::Converter

  module Atom

    mattr_reader :media_type_name
    @@media_type_name = 'application/atom+xml'

    mattr_reader :headers
    @@headers = { 
      :get  => { 'Accept'       => media_type_name },
      :post => { 'Content-Type' => media_type_name }
    }

    mattr_reader :recipes
    @@recipes = {}

    class << self
      
      def helper
        Restfulie::Common::Converter::Atom::Helpers
      end

      def describe_recipe(recipe_name, options={}, &block)
        raise 'Undefined recipe' unless block_given?
        raise 'Undefined recipe_name'   unless recipe_name
        @@recipes[recipe_name] = block
      end

      def to_atom(obj = nil, options = {}, &block)
        # just instantiate the string with the atom factory
        return Restfulie::Common::Representation::Atom::Factory.create(obj) if obj.kind_of?(String)
        
        if block_given?
          recipe = block
        elsif options[:recipe]          
          recipe = @@recipes[options[:recipe]]
        else
          return obj if obj.respond_to?(:atom_type) && (obj.atom_type == "feed" || obj.atom_type == "entry")
          raise Restfulie::Common::Error::ConverterError.new("Recipe required")
        end
        
        # execute with the builder if a recipe is set (even if the obj is an atom)
        options[:atom_type] ||= obj.respond_to?(:each) ? :feed : :entry
        raise Restfulie::Common::Error::ConverterError.new("Undefined atom type #{options[:atom_type]}") unless [:entry,:feed].include?(options[:atom_type])

        # Create representation and proxy
        builder = Builder.new(options[:atom_type], obj)

        # Check recipe arity size before calling it
        recipe.call(*[builder, obj, options][0,recipe.arity])

        builder.representation
      end
      
      alias_method :unmarshal, :to_atom

      def to_hash(obj)
        return obj if obj.kind_of?(Hash)

        xml = nil
        
        if obj.kind_of?(::String)
           xml = obj
        elsif obj.respond_to?(:to_xml)
           xml = obj.to_xml
        end

        Hash.from_xml(xml).with_indifferent_access unless xml.nil?
      end


      def to_s(obj)
        return obj if obj.kind_of?(String)
        if obj.respond_to?(:to_xml)
          obj.to_xml.to_s
        else
          obj.to_s
        end
      end

      def marshal(obj, options = nil)
        to_atom(obj, options).to_xml
      end

    end
  end
end
