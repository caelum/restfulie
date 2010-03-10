require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

context Restfulie::Builder::CollectionRule do
  
  it "should allow create a rule for resources" do
    collection_rule = Restfulie::Builder::CollectionRule.new
    member_builder  = collection_rule.describe_members
    member_builder.should be_kind_of(Restfulie::Builder::Base)
    collection_rule.describe_members_builder.should == member_builder
  end

end