require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie::Server::Instance do
  
  context "when checking available transitions" do
    
    before do
      @o = Object.new
      @o.extend Restfulie::Server::Instance
    end
    
    it "should return true if the object has a transition named after the required string or symbol" do
      hash = Hashi::CustomHash.new("name" => :execute)
      @o.stub(:all_following_transitions).and_return([hash])
      @o.can?(:execute).should be_true
      @o.can?("execute").should be_true
    end
    
    it "should return false if the object has a transition named after the required string or symbol" do
      @o.stub(:all_following_transitions).and_return([])
      @o.can?(:execute).should be_false
      @o.can?("execute").should be_false
    end
    
  end

end
