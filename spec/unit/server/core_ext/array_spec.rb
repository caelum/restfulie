require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Array do
  
  class SimpleElement
    attr_accessor :updated_at, :published_at
    def initialize
      @updated_at = @published_at = Time.now
    end
  end

  it "creates an Atom feed based on the array elements" do
    array = []
    3.times { array << SimpleElement.new }

    array.each { |a|
      a.should_receive(:to_atom).and_return(Tokamak::Representation::Atom::Entry.new)
    }
    
    feed = array.to_atom
    
    feed.title.should == "Collection of SimpleElement"
    feed.updated.to_s.should == array.last.updated_at.to_s
    feed.published.to_s.should == array.first.published_at.to_s
    
    feed.id.to_s.should == array.hash.to_s
    
    feed.entries.size.should == 3
    feed.entries.first.should be_kind_of(Tokamak::Representation::Atom::Entry)
  end
  
  it "accepts a block to customize fields" do
    
    array = []
    a = false
    array.to_atom do |f|
      a = true
      f.should be_kind_of(Tokamak::Representation::Atom::Feed)
    end
    a.should be_true
    
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