require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Restfulie::Common::Representation::Links do
  it "should extract link header from links" do
    link1 = Restfulie::Common::Representation::Atom::Link.new(:rel => "home", :href => "http://google.com")
    link2 = Restfulie::Common::Representation::Atom::Link.new(:rel => "next", :href => "http://google.com?q=ruby")
    links = [link1, link2]
    
    Restfulie::Common::Representation::Links.extract_link_header(links).should == "<http://google.com>; rel=home, <http://google.com?q=ruby>; rel=next"
  end  
end
