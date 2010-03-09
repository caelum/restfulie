class Restfulie::Builder::CollectionRule < Restfulie::Builder::Rules::Base
  attr_reader :describe_members_rule
  
  def describe_members(&block)
    @describe_members_rule = Restfulie::Builder::MemberRule.new(&block)
  end
  
end