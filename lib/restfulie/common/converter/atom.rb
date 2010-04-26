module Restfulie::Common::Converter

  module Atom

    REQUIRED_ATTRIBUTES = {
      :feed  => [:title, :id, :updated],
      :entry => [:title, :id, :updated] 
    }

    mattr_reader :recipes
    @@recipes = {
      :default_feed => lambda do |obj,feed|
        REQUIRED_ATTRIBUTES[:feed].each do |attr_sym|
          feed.send("#{attr_sym}=".to_sym,obj.send(attr_sym)) if obj.respond_to?(attr_sym)
        end
      end,
      :default_entry => lambda do |obj,entry|
        REQUIRED_ATTRIBUTES[:entry].each do |attr_sym|
          entry.send("#{attr_sym}=".to_sym,obj.send(attr_sym)) if obj.respond_to?(attr_sym)
        end
      end
    }

    def self.describe_recipe(recipe_name, options={}, &block)
      raise 'Undefined recipe' unless block_given?
      raise 'Undefined recipe_name'   unless recipe_name
      @@recipes[recipe_name] = block
    end

    def self.link(options)
      ::Atom::Link.new(options)
    end

    def to_atom(recipe_name=nil,atom_type=:entry)
      raise "Undefined atom type #{atom_type}" unless [:entry,:feed].include?(atom_type)

      #TODO Code smell.
      if is_a?(::String)

        begin 
          if atom_type == :entry
            atom_type = :feed
            atom = ::Atom::Feed.load_feed(self)
          else
            atom_type = :entry
            atom = ::Atom::Entry.load_entry(self) 
          end
        rescue
          atom_type = atom_type == :entry ? :feed : :entry
          atom = to_atom(recipe_name,atom_type)
        end

      else

        recipe = @@recipes[recipe_name] || @@recipes["default_#{atom_type}".to_sym]
        begin
          atom = "::Atom::#{atom_type.to_s.camelize}".constantize.new
          recipe.call(self,atom)
        rescue 
          atom_type = atom_type == :entry ? :feed : :entry
          atom = "::Atom::#{atom_type.to_s.camelize}".constantize.new
          recipe = @@recipes[recipe_name] || @@recipes["default_#{atom_type}".to_sym]
          recipe.call(self,atom)
        end

      end

      REQUIRED_ATTRIBUTES[atom_type].each do |attr_sym|
        raise "Undefined required value #{attr_sym} from #{atom}" unless atom.send(attr_sym)
      end
      atom
    end

  end

end
