module Restfulie::Common::Converter

  module Atom

    mattr_reader :media_type_name
    @@media_type_name = 'application/atom+xml'

    mattr_reader :headers
    @@headers = { 
      :get  => { 'Accept'       => media_type_name },
      :post => { 'Content-Type' => media_type_name }
    }

    REQUIRED_ATTRIBUTES = {
      :feed  => [:title, :id, :updated],
      :entry => [:title, :id, :updated] 
    }

    mattr_reader :recipes
    @@recipes = {}

    REQUIRED_ATTRIBUTES.keys.each do |type|
      @@recipes["default_#{type}".to_sym] = lambda do |atom, obj, options|
        REQUIRED_ATTRIBUTES[type].each do |attr_sym|
          values   = options[:values][attr_sym] rescue nil
          silence_warnings { values ||= obj.send(attr_sym) if obj.respond_to?(attr_sym) }
          atom.send("#{attr_sym}=".to_sym, values)
        end

        atom.updated ||= updated(obj)
        atom.title ||= type == :feed ? "#{obj.first.class.to_s.pluralize.demodulize} feed" : "Entry about #{obj.class.to_s.demodulize}"
      end
    end

    class << self

      def describe_recipe(recipe_name, options={}, &block)
        raise 'Undefined recipe' unless block_given?
        raise 'Undefined recipe_name'   unless recipe_name
        @@recipes[recipe_name] = block
      end

      def link(options)
        ::Atom::Link.new(options)
      end

      def to_atom(obj, options = {}, &recipe)
        options[:atom_type] ||= obj.respond_to?(:each) ? :feed : :entry

        raise Restfulie::Common::Error::ConverterError.new("Undefined atom type #{options[:atom_type]}") unless [:entry,:feed].include?(options[:atom_type])

        if obj.kind_of?(::String)
          atom = ::Atom.load(obj)
        else
          
          recipes = ["default_#{options[:atom_type]}".to_sym]
          unless options[:recipes].nil?
             recipes += options[:recipes].kind_of?(Array) ? options[:recipes] : [options[:recipes]]
          end
          recipes << recipe if block_given?

          # Get recipes in recipes list
          recipes.map! { |item| item.respond_to?(:call) ? item : @@recipes[item] }
          atom   = "::Atom::#{options[:atom_type].to_s.camelize}".constantize.new

          # Check recipe arity size before calling it
          recipes.each do |recipe|
            recipe.call(*[atom, obj, options][0,recipe.arity])
          end
        end

        REQUIRED_ATTRIBUTES[options[:atom_type]].each do |attr_sym|
          raise Restfulie::Common::Error::ConverterError.new("Undefined required value #{attr_sym} from #{atom.class}") unless atom.send(attr_sym)
        end
        atom
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

    private 

      def updated(obj)
        if obj.respond_to?(:updated_at)
          obj.updated_at 
        elsif obj.respond_to?(:map)
          obj.map { |item| item.updated_at if item.respond_to?(:updated_at) }.compact.max
        else
          Time.now
        end
      end

    end
  end
end
