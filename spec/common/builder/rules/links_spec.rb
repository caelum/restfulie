require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

context Restfulie::Builder::Rules::Links do
  it "should extend Array" do
    Restfulie::Builder::Rules::Links.ancestors.should be_include(Array)
  end

  it "should allow delete for rel attribute" do
    link  = create_link(:self)
    links = Restfulie::Builder::Rules::Links.new([link])
    links.delete(:self).should equal(link)
  end

  it "should allow normal delete" do
    link  = create_link(:self)
    links = Restfulie::Builder::Rules::Links.new([link])
    links.delete(link).should equal(link)
  end
end

def create_link(*args)
  Restfulie::Builder::Rules::Link.new(*args)
end