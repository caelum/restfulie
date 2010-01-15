require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie::Server::Instance do
  
  before do
    @o = Object.new
    @o.extend Restfulie::Server::Instance
  end

  context "when checking available transitions" do
    
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
    
    it "should add the available transition from the dsl" do
      available = Object.new
      @o.should_receive(:following_transitions).and_return([])
      @o.should_receive(:available_transitions).and_return({:allow => [available]})
      @o.all_following_transitions.should eql([available])
      
    end
    
    it "should translate array based transitions into real ones" do
      available = []
      @o.should_receive(:following_transitions).and_return([available])
      @o.should_receive(:available_transitions).and_return({:allow => []})
      trans = Object.new
      Restfulie::Server::Transition.should_receive(:new).with(available).and_return(trans)
      @o.all_following_transitions.should eql([trans])
    end
    
    it "should add transition if itself is available" do
      available = Object.new
      @o.should_receive(:following_transitions).and_return([available])
      @o.should_receive(:available_transitions).and_return({:allow => []})
      @o.all_following_transitions.should eql([available])
    end
    
  end
  
  context "when locating links" do
    
    it "should return no link if there is no controller" do
      @o.links(nil).should eql([])
    end
    
    it "should return a link for every transition" do
      t1 = Object.new
      t2 = Object.new
      controller = Object.new
      @o.should_receive(:all_following_transitions).and_return([t1, t2])
      @o.should_receive(:link_for).with(t1, controller).and_return(["rel1", "uri1"])
      @o.should_receive(:link_for).with(t2, controller).and_return(["rel2", "uri2"])
      links = @o.links(controller)
      links[0][:rel].should eql("rel1")
      links[0][:uri].should eql("uri1")
      links[1][:rel].should eql("rel2")
      links[1][:uri].should eql("uri2")
    end
    
  end

end
