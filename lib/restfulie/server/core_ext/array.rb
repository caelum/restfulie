class Array
  def to_atom(options={}, &block)
    raise "Not all elements respond to to_atom" unless all? { |e| e.respond_to? :to_atom }
    options = options.dup
  
    Atom::Feed.new do |feed|
      # TODO: Define better feed attributes
      # Array#to_s can return a very long string
      feed.title   = "Collection of #{map {|i| i.class.name }.uniq.to_sentence}"
      # TODO: this id does not comply with Rest standards yet
      feed.id      = hash
      feed.updated = updated_at
    
      each do |element|
        feed.entries << element.to_atom(options)
      end
      
      yield feed if block_given?
    end
  end
    
  def updated_at
    map { |item| item.updated_at if item.respond_to?(:updated_at) }.compact.max || Time.now
  end
end