module CompareAtoms
  def eql_xml?(xml)
    self.to_xml == self.class.send("load_#{self.class.to_s.demodulize.downcase}".to_sym, xml).to_xml
  end
end

Atom::Feed.send(:include, CompareAtoms)
Atom::Entry.send(:include, CompareAtoms)
