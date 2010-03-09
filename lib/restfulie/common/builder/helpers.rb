module Restfulie::Builder::Helpers

  def member(&block)
    create_rule(Restfulie::Builder::MemberRules, &block)
  end

  def collection(&block)
    create_rule(Restfulie::Builder::CollectionRules, &block)
  end

private

  def create_rule(rule, *args, &block)
    rules = block_given? ? [rule.new(&block)] : []
    Restfulie::Builder::Base.new(rules)
  end
end