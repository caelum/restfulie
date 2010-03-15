require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

context Restfulie::Builder::CollectionRule do

  it "should allow create a rule for resources" do
    collection_rule = Restfulie::Builder::CollectionRule.new
    block = lambda {}

    collection_rule.describe_members(:eagerload => [:values], &block)

    collection_rule.members_blocks.should be_include(block)
    collection_rule.members_options[:eagerload].should == [:values]
  end

end