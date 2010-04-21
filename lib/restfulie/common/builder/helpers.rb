module Restfulie::Common::Builder::Helpers

  def describe_member(member, options = {}, &block)
    create_builder(member, options, &block)
  end
  
  def describe_collection(collection, options = {}, &block)
    create_builder(collection, options, &block)
  end
  
  # Helper to create objects link
  def link(*args)
    Restfulie::Common::Builder::Rules::Link.new(*args)
  end

  # Create object Content::Text
  def text(*args)
    ::Atom::Content::Text.new(*args)
  end

  # Create object Content::Html
  def html(*args)
    ::Atom::Content::Html.new(*args)
  end

  # Create object Content::Xhtml
  def xhtml(*args)
    ::Atom::Content::Xhtml.new(*args)
  end
  
private

  def create_builder(object, options, &block)
    Restfulie::Common::Builder::Base.new(object, block_given? ? [block] : [], options)
  end

end
