require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::Mikyung::WhenCondition do
  
  before do
    @rule = [""]
    @params = Object.new
    @condition = Restfulie::Client::Mikyung::WhenCondition.new(nil, @rule, @params)
    @resource = Object.new
    @goal = Object.new
    @mikyung = Object.new
  end

  it "should execute for every result concatenated" do
    obj = Object.new
    def obj.description
      "will execute something special"
    end
    @condition.results_on obj
    
    result = Object.new
    obj.should_receive(:execute).with(@resource, @goal, @mikyung).and_return(result)
    
    @condition.execute(@resource, @goal, @mikyung).should == result
  end
  
  it "should not run if its rule without params does not match" do
    @rule << lambda { |without| false }
    @condition.should_run_for(@resource, @goal).should be_false
  end

  it "should not run if its rule with params does not match" do
    @rule << lam(false)
    @condition.should_run_for(@resource, @goal).should be_false
  end
  
  def lam(what)
    lambda { |without, regex| what }
  end
  
  it "should run if its rule says so" do
    @rule << lam(true)
    @condition.should_run_for(@resource, @goal).should be_true
  end
  
  it "should run if its rule and extras says so" do
    @rule << lam(true)
    @condition.and Restfulie::Client::Mikyung::WhenCondition.new(nil, ["", lam(true)], @params)
    @condition.should_run_for(@resource, @goal).should be_true
  end
  
  it "should not run if its rule says yes but extras no" do
    @rule << lam(true)
    @condition.and Restfulie::Client::Mikyung::WhenCondition.new(nil, ["", lam(false)], @params)
    @condition.should_run_for(@resource, @goal).should be_false
  end
  
end

