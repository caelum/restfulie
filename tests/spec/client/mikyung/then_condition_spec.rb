require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class BasicGoal
  attr_accessor :then_rules
end

context Restfulie::Client::Mikyung::ThenCondition do
  
  before do
    @condition = Restfulie::Client::Mikyung::ThenCondition.new("launch a rocket")
    @resource = Object.new
    @goal = BasicGoal.new
    @mikyung = Object.new
    @goal.then_rules = []
    @goal.then_rules << ["send an email", ""]
  end
  
  it "should do nothing if there is no matching rule" do
    @condition.execute(@resource, @goal, @mikyung).should == nil
  end
  
  it "should invoke with resource if it receives one parameter" do
    @goal.then_rules << ["launch a rocket", lambda { |resource| true }]
    @condition.execute(@resource, @goal, @mikyung).should be_true
  end
  
  it "should invoke with two params if it receives two parameters" do
    @goal.then_rules << ["launch a rocket", lambda { |resource, params| true }]
    @condition.execute(@resource, @goal, @mikyung).should be_true
  end
  
  it "should invoke with all params if it receives three parameters" do
    @goal.then_rules << ["launch a rocket", lambda { |resource, params, mikyung| true }]
    @condition.execute(@resource, @goal, @mikyung).should be_true
  end
  
end

