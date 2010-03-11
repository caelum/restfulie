module Restfulie::Builder::Helpers

  def describe_member(member, &block)
    create_builder(member, &block)
  end
  
  def describe_collection(collection, &block)
    create_builder(collection, &block)
  end
  
  # Helper to create objects link
  def link(*args)
    Restfulie::Builder::Rules::Link.new(*args)
  end
  
private

  def create_builder(object, &block)
    Restfulie::Builder::Base.new(object, block_given? ? [block] : [])
  end

end