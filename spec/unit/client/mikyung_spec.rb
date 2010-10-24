require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::Mikyung do

  context "when trying to achieve a goal" do
  
    before do
      @goal = Object.new
      @start = Object.new
      @walker = Object.new
      @client = Restfulie::Mikyung.new.achieve(@goal).at(@start).walks_with(@walker)
    end
  
    it "should allow access to its goal" do
      @client.goal.should == @goal
    end

    it "should allow access to its start point" do
      @client.start.should == @start
    end
    
    it "should allow access to its steady state walker" do
      @client.walker.should == @walker
    end

    it "should not walk if goal starts completed" do
      @goal.should_receive(:completed?).with(@start).and_return(true)
      @restfulie = mock Restfulie::Client::Mikyung
      @restfulie.should_receive(:get).and_return(@start)
      @goal.class.should_receive(:get_restfulie).and_return(@restfulie)
      @goal.should_receive(:steps).and_return(nil)
      @goal.should_receive(:scenario).and_return(nil)
      @client.run
    end
    
    it "should walk until its completed" do
      @goal.should_receive(:completed?).with(@start).and_return(false)
      second = Object.new
      @walker.should_receive(:move).with(@goal, @start, @client).and_return(second)
      @goal.should_receive(:completed?).with(second).and_return(true)
      @restfulie = mock Restfulie::Client::Mikyung
      @restfulie.should_receive(:get).and_return(@start)
      @goal.class.should_receive(:get_restfulie).and_return(@restfulie)
      @goal.should_receive(:steps).and_return(nil)
      @goal.should_receive(:scenario).and_return(nil)
     @client.run
    end
    
  end
  
  context "starting with an URI" do
    
    it "should start invoking a restfulie get if the entry point is an uri" do
      start = "http://www.caelumobjects.com"
      restfulie = mock Restfulie::Client::Mikyung
      Restfulie.should_receive(:at).with(start).and_return(restfulie)
      
      resource = Object.new
      restfulie.should_receive(:get).and_return(resource)

      client = Object.new
      walker = Object.new
      goal = Object.new
      goal.should_receive(:completed?).with(resource).and_return(true)
      goal.should_receive(:steps).and_return(nil)
      goal.should_receive(:scenario).and_return(nil)
     Restfulie::Mikyung.new.achieve(goal).at(start).run
    end
    
  end

end
