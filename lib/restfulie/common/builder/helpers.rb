module Restfulie::Builder::Helpers

  def describe_member(member, &block)
    create_builder(member, Restfulie::Builder::MemberRule, &block)
  end
  
  def describe_collection(collection, &block)
    create_builder(collection, Restfulie::Builder::CollectionRule, &block)
  end
  
  # Helper to create objects link
  def link(*args)
    Restfulie::Builder::Rules::Link.new(*args)
  end
  
private

  def create_builder(object, rule_class, &block)
    rule = block_given? ? [rule_class.new(&block)] : []
    Restfulie::Builder::Base.new(object, rule)
  end

end