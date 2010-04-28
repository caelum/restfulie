module Restfulie::Common::Converter

  module Atom

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

    def self.describe_recipe(recipe_name, options={}, &block)
      raise 'Undefined recipe' unless block_given?
      raise 'Undefined recipe_name'   unless recipe_name
      @@recipes[recipe_name] = block
    end

    def self.link(options)
      ::Atom::Link.new(options)
    end

    def to_atom(recipe_name = nil, atom_type = :entry)
      raise Restfulie::Common::Error::ConverterError.new("Undefined atom type #{atom_type}") unless [:entry,:feed].include?(atom_type)

      if self.is_a?(::String)
        atom = ::Atom.load(self)
      else
        recipe = @@recipes[recipe_name] || @@recipes["default_#{atom_type}".to_sym]
        atom   = "::Atom::#{atom_type.to_s.camelize}".constantize.new
        recipe.call(atom, self)
      end

      REQUIRED_ATTRIBUTES[atom_type].each do |attr_sym|
        raise Restfulie::Common::Error::ConverterError.new("Undefined required value #{attr_sym} from #{atom.class}") unless atom.send(attr_sym)
      end
      atom
    end

  end

end
