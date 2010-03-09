class Restfulie::Builder::CollectionRules < Restfulie::Builder::Rules::Base
  attr_reader :describe_members_rule
  
  def describe_members(&block)
    @describe_members_rule = Restfulie::Builder::MemberRules.new(&block)
  end
  
end