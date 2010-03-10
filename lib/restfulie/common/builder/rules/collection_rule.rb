class Restfulie::Builder::CollectionRule < Restfulie::Builder::Rules::Base
  attr_reader :describe_members_builder
  
  def describe_members(options = {}, &block)
    members_rule = Restfulie::Builder::MemberRule.new(&block)
    @describe_members_builder = Restfulie::Builder::Base.new(members_rule)
  end
  
end