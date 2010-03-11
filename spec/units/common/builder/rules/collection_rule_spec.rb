require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

context Restfulie::Builder::CollectionRule do
  
  it "should allow create a rule for resources" do
    collection_rule  = Restfulie::Builder::CollectionRule.new
    member_rule      = collection_rule.describe_members
    member_rule.should be_kind_of(Restfulie::Builder::MemberRule)
    collection_rule.describe_members_rule.should == member_rule
  end

end