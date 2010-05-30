require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie::Client::Mikyung do

  context "when trying to achieve a goal" do
  
    before do
      @goal = Object.new
      @client = Object.new
      @start = Object.new
      @walker = Object.new
      @client = Restfulie::Mikyung.new.achieve(@goal).at(@start).walks_with(@walker)
    end
  
    it "should allow access to its goal, starting point and steady state walker" do
      @client.goal.should == @goal
      @client.start.should == @start
      @client.walker.should == @walker
    end

    it "should not walk if goal starts completed" do
      @goal.should_receive(:completed?).with(@start).and_return(true)
      @client.run
    end
    
    it "should walk until its completed" do
      @goal.should_receive(:completed?).with(@start).and_return(false)
      second = Object.new
      @walker.should_receive(:move).with(@goal, @start, @client).and_return(second)
      @goal.should_receive(:completed?).with(second).and_return(true)
      @client.run
    end
    
  end
  
  context "starting with an URI" do
    
    it "should start invoking a restfulie get if the entry point is an uri" do
      start = "http://www.caelumobjects.com"
      restfulie = Object.new
      Restfulie.should_receive(:at).with(start).and_return(restfulie)
      
      resource = Object.new
      restfulie.should_receive(:get).and_return(resource)

      client = Object.new
      walker = Object.new
      goal = Object.new
      goal.should_receive(:completed?).with(resource).and_return(true)
      Restfulie::Mikyung.new.achieve(goal).at(start).run
    end
    
  end

end
