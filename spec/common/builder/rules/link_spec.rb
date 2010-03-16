require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

context Restfulie::Common::Builder::Rules::Link do
  it "should create link with rel" do
    @link = create_link('self')
    @link.rel.should == 'self'
  end

  it "should converted rel for string" do
    @link = create_link(:self)
    @link.rel.should == 'self'
  end

  it "should create link options with rel" do
    url   = "http://example.com/songs/1"
    @link = create_link(:rel => 'self', :href => url)

    @link.rel.should  == 'self'
    @link.href.should == url
  end
end # context Restfulie::Common::Builder::Rules::Link

def create_link(*args)
  Restfulie::Common::Builder::Rules::Link.new(*args)
end