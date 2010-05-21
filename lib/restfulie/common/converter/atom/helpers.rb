module Restfulie::Common::Converter::Atom::Helpers
  def collection(obj, *args, &block)
    Restfulie::Common::Converter::Atom.to_atom(obj, :atom_type => :feed, &block)
  end

  def member(obj, *args, &block)
    Restfulie::Common::Converter::Atom.to_atom(obj, :atom_type => :entry, &block)
  end
end