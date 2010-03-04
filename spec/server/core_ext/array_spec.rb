require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Array do

  before(:each) do
    @array = []
    3.times { @array << AtomifiedModel.new }
  end

  it "creates an Atom feed based on the array elements" do
    feed = @array.to_atom
    feed = feed.to_xml
    feed.should include("<feed xmlns=\"http://www.w3.org/2005/Atom\">")
    feed.should include("<published>123</published>")
    feed.should include("<title>Collection of AtomifiedModel")
    feed.should include("</feed>")
  end
  
  it "accepts a block to customize fields" do
    feed = @array.to_atom do |f|
      f.title = "customized title" 
      f.authors << Atom::Person.new(:name => 'John Doe')
    end.to_xml
    
    feed.should include("<title>customized title</title")
    feed.should include("<author>")
    feed.should include("<name>John Doe</name")
  end
end