require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/models')

context Array do

  before(:each) do
    @array = []
    3.times { @array << AtomifiedModel.new }
  end

  it "creates an Atom feed based on the array elements" do
    feed = @array.to_atom
    feed = feed.to_xml
    feed.should include("<feed xmlns=\"http://www.w3.org/2005/Atom\"")
    feed.should include("<published>2010-05-03T16:29:26Z</published>")
    feed.should include("<title>Collection of AtomifiedModel")
    feed.should include("</feed>")
  end
  
  it "accepts a block to customize fields" do
    
    feed = @array.to_atom do |f|
      f.title = "customized title"
      f.authors << Restfulie::Common::Representation::Atom::Person.new("author", :name => 'John Doe')
    end.to_xml
    
    feed.should include("<title>customized title</title")
    feed.should include("<author>")
    feed.should include("<name>John Doe</name")
  end
  
  it "get the max time to update the items" do
    Album.create(:title => 'Array test')
    Album.update_all(:updated_at => Time.now - 1.day)
    Album.first.update_attributes(:updated_at => Time.now)
    Album.all.updated_at.should == Album.first.updated_at
  end
  
  it "custom field usinged to find max updated" do
    album = Album.create(:title => 'Array test')
    Album.all.updated_at(:created_at).to_i.should == album.created_at.to_i
  end
end