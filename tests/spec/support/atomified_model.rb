class AtomifiedModel
  attr_writer   :new_record
  attr_reader   :updated_at
  
  def initialize(updated_at = Time.now)
    @updated_at = updated_at
  end

  def new_record?
    @new_record || false
  end

  def to_atom(options={})
    entry = Restfulie::Common::Representation::Atom::Entry.new
    entry.id        = "entry1"
    entry.title     = "entry"
    entry.updated   = Time.parse("2010-05-03T16:29:26Z")
    entry.published = published_at
    entry
  end
  
  def published_at
    Time.parse("2010-05-03T16:29:26Z")
  end
end
