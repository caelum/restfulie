module Restfulie::Builder::Helpers

  def describe(object, &block)
    rule_class = object.class.ancestors.include?(Enumerable) ?
      Restfulie::Builder::CollectionRule :
      Restfulie::Builder::MemberRule

    rule = block_given? ? [rule_class.new(&block)] : []
    Restfulie::Builder::Base.new(object, rule)
  end
  
  # Helper to create objects link
  def link(*args)
    Restfulie::Builder::Rules::Link.new(*args)
  end
end