# Introspective methods to assist in the conversion of collections in other formats.
class Array
  def to_atom(options={}, &block)
    raise "Not all elements respond to to_atom" unless all? { |e| e.respond_to? :to_atom }
    options = options.dup
    
    if options.delete :only_self_link
      options[:skip_associations_links] = true
      options[:skip_attributes]         = true      
    end
    
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
  
  # Return max update date for items in collection, for it uses the updated_at of items.
  # 
  #==Example:
  #
  # Find max updated at in ActiveRecord objects 
  #
  #   albums = Albums.find(:all)
  #   albums.updated_at
  # 
  # Using a custom field to check the max date
  #
  #   albums = Albums.find(:all)
  #   albums.updated_at(:created_at)
  #
  def updated_at(field = :updated_at)
    map { |item| item.send(field) if item.respond_to?(field) }.compact.max || Time.now
  end
end