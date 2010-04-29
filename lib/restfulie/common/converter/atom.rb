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
    @@recipes = {
      :default_feed => lambda do |feed, obj|
        REQUIRED_ATTRIBUTES[:feed].each do |attr_sym|
          feed.send("#{attr_sym}=".to_sym,obj.send(attr_sym)) if obj.respond_to?(attr_sym)
        end
      end,
      :default_entry => lambda do |entry, obj|
        REQUIRED_ATTRIBUTES[:entry].each do |attr_sym|
          entry.send("#{attr_sym}=".to_sym,obj.send(attr_sym)) if obj.respond_to?(attr_sym)
        end
      end,
    }

    class << self

      def describe_recipe(recipe_name, options={}, &block)
        raise 'Undefined recipe' unless block_given?
        raise 'Undefined recipe_name'   unless recipe_name
        @@recipes[recipe_name] = block
      end

      def link(options)
        ::Atom::Link.new(options)
      end

      def to_atom(obj, recipe_name = nil, atom_type = :entry, &recipe)
        raise Restfulie::Common::Error::ConverterError.new("Undefined atom type #{atom_type}") unless [:entry,:feed].include?(atom_type)

        if obj.kind_of?(::String)
          atom = ::Atom.load(obj)
        else
          recipe = @@recipes[recipe_name] || @@recipes["default_#{atom_type}".to_sym] unless block_given?
          atom   = "::Atom::#{atom_type.to_s.camelize}".constantize.new
          # Check recipe arity size before calling it
          recipe.call(*[atom, obj][0,recipe.arity])
        end

        REQUIRED_ATTRIBUTES[atom_type].each do |attr_sym|
          raise Restfulie::Common::Error::ConverterError.new("Undefined required value #{attr_sym} from #{atom.class}") unless atom.send(attr_sym)
        end
        atom
      end

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

      alias_method :unmarshal, :to_atom
      alias_method :marshal, :to_s

    end
  end
end
