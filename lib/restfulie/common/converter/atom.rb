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

      def describe_recipe(recipe_name, options={}, &block)
        raise 'Undefined recipe' unless block_given?
        raise 'Undefined recipe_name'   unless recipe_name
        @@recipes[recipe_name] = block
      end

      def to_atom(obj = nil, options = {}, &recipe)
        options[:atom_type] ||= obj.respond_to?(:each) ? :feed : :entry

        raise Restfulie::Common::Error::ConverterError.new("Undefined atom type #{options[:atom_type]}") unless [:entry,:feed].include?(options[:atom_type])
        
        recipes = []
        unless options[:recipes].nil?
           recipes += options[:recipes].kind_of?(Array) ? options[:recipes] : [options[:recipes]]
        end
        recipes << recipe if block_given?

        # Check if we got recipes
        raise Restfulie::Common::Error::ConverterError.new("Recipe required") if recipes.empty?

        # Get recipes in recipes list
        recipes.map! { |item| item.respond_to?(:call) ? item : @@recipes[item] }

        # Create representation and proxy
        builder = Builder.new(options[:atom_type])

        # Check recipe arity size before calling it
        recipes.each do |recipe|
          recipe.call(*[builder, obj, options][0,recipe.arity])
        end

        builder.representation
      end
      
      alias_method :unmarshal, :to_atom

      def to_hash(obj)
        return obj if obj.kind_of?(Hash)

        xml = nil
        # TODO: Add validate atom string
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

      def marshal(obj, recipes = nil)
         to_atom(obj, :recipes => recipes).to_xml
      end

    end
  end
end
