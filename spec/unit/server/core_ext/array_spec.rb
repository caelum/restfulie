require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Array do
  
  class SimpleElement
    attr_accessor :updated_at, :published_at
    def initialize
      @updated_at = @published_at = Time.now
    end
  end

  it "should use the most recent date as updated one" do
    first = SimpleElement.new
    second = SimpleElement.new
    
    [first, second].updated_at.should == second.updated_at
    [first, first].updated_at.should == first.updated_at
    
    now = Time.now
    Time.should_receive(:now).and_return(now)
    [].updated_at.should == now
  end
  
  it "should return the oldest published date" do
    first = SimpleElement.new
    second = SimpleElement.new

    [first, second].published_at.should == first.published_at
    [first, first].published_at.should == first.published_at
    
    now = 545
    Time.should_receive(:now).and_return(now)
    [].updated_at.should == now
  end
end