require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class AtomifiedModel 
  def to_atom
    Atom::Entry.new do |entry|
      entry.title     = "entry"
      entry.published = '123'
      entry.updated   = '123'
    end
  end
end

context Restfulie::Server::CoreExtensions::Array do

  before(:each) do
    @array = []
    3.times { @array << AtomifiedModel.new }
  end

  it "creates an Atom feed based on the array elements" do
    feed = @array.to_atom
    feed = feed.to_xml
    feed.should include("<feed xmlns=\"http://www.w3.org/2005/Atom\">")
    feed.should include("<published>123</published>")
    feed.should include("<title>#&lt;AtomifiedModel")
    feed.should include("</feed>")
  end
end