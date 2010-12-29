require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe Restfulie::Client::Mikyung::WhenCondition do
  
  class MyProcess < Restfulie::Client::Mikyung::RestProcessModel
    def scenario
      When "there are products" do |resource|
        true
      end

      When "alive" do |resource|
        true
      end
    
      When "dead" do |resource|
        false
      end
      
      Then "rest" do |resource|
      end
    end
    
  end
  
  before do
    @process = MyProcess.new
    @process.scenario
  end
  
  context "configuring" do
  
    it "should concatenate when method missing" do
      def @process.scenario
        nobody
      end
      @process.scenario.content.should == "nobody"
    end
  
    it "should start a concatenate when method missing" do
      def @process.scenario
        nobody but you
      end
      @process.scenario.content.should == "nobody but you"
    end
  
    it "should create a when rule when passing a string" do
      l = lambda { |resource| @executed = true}
      def @process.scenario(l)
        When "something happens" do |resource|
          l.call(resource)
        end
      end
      @process.scenario(l)
      @process.when_rules.size.should == 4
      @process.when_rules[3][0].should == "something happens"
      @process.when_rules[3][1].call("resource")
      @executed.should be_true
    end
  
    it "should create a new rule when using concatenators" do
      def @process.scenario
        When alive
      end
      @process.scenario
      @process.conditions.size.should == 1
    end
  
    it "should complain about a rule that does not yet exist" do
      def @process.scenario
        When studying
      end
      lambda {@process.scenario}.should raise_error(Restfulie::Client::Mikyung::ConfigurationError)
    end

    it "should add further restrictions" do
      def @process.scenario
        When alive
        And dead
      end
      @process.scenario
      @process.conditions.size.should == 1
    end

    it "should add results" do
      def @process.scenario
        When alive
        Then rest
      end
      @process.scenario
      @process.then_rules.size.should == 1
    end
  
    it "should create extra results" do
      def @process.scenario
        Then "play" do |resource|
        end
      
        When alive
        Then play
      end
      @process.scenario
      @process.then_rules.size.should == 2
    end

  end
  
  context "running" do
    
    it "should do nothing if there are no conditions" do
      @process.next_step(nil,nil).should be_nil
    end
    
    it "should do nothing if there is no condition which should be run" do
      def @process.scenario
        Then "complain" do
          "complained"
        end
        When dead
        Then complain
      end
      @process.scenario
      @process.next_step(nil,nil).should be_nil
    end
    
    it "should do something if it matches" do
      def @process.scenario
        Then "buy" do
          "next step executed"
        end
        When there are products
        Then buy
      end
      @process.scenario
      @process.next_step(nil,nil).should == "next step executed"
    end
    
  end
  
end

