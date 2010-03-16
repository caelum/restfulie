require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

context Restfulie::Common::Builder::Rules::Links do
  it "should extend Array" do
    Restfulie::Common::Builder::Rules::Links.ancestors.should be_include(Array)
  end

  it "should allow delete for rel attribute" do
    link  = create_link(:self)
    links = Restfulie::Common::Builder::Rules::Links.new([link])
    links.delete(:self).should equal(link)
  end

  it "should allow normal delete" do
    link  = create_link(:self)
    links = Restfulie::Common::Builder::Rules::Links.new([link])
    links.delete(link).should equal(link)
  end
end

def create_link(*args)
  Restfulie::Common::Builder::Rules::Link.new(*args)
end