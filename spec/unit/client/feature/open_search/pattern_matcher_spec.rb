require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe Restfulie::Client::Feature::OpenSearch::PatternMatcher do
  
  context "matching patterns" do
  
    it "should unmarshall opensearch xml descriptions" do
      pattern = "q={searchTerms}&amp;pw={startPage?}&amp;format=atom"
      matcher = Restfulie::Client::Feature::OpenSearch::PatternMatcher.new
      matcher.match({:searchTerms => 12, :startPage => 13},pattern).should == "q=12&amp;pw=13&amp;format=atom"
    end
  
    it "should reset optional patterns" do
      pattern = "q={searchTerms}&amp;pw={startPage?}&amp;format=atom"
      matcher = Restfulie::Client::Feature::OpenSearch::PatternMatcher.new
      matcher.match({:searchTerms => 12},pattern).should == "q=12&amp;pw=&amp;format=atom"
    end
  
  end

end