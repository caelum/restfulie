require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Restfulie::Common::Representation::Atom do
  before :all do
    full_atom = IO.read(File.dirname(__FILE__) + '/../full_atom.xml')
    @atom = Restfulie::Common::Representation::Atom::Factory.create(full_atom)
  end
  
  describe "Atom creation" do
    it "should be able to create an empty Feed object" do
      feed = Restfulie::Common::Representation::Atom::Feed.new
      feed.id = "new_id"
      feed.title = "new title"
      a_time = Time.now
      feed.updated = a_time
      
      feed.id.should == "new_id"
      feed.title.should == "new title"
      feed.updated.should be_kind_of(Time)
      feed.updated.should == Time.parse(a_time.to_s)     
    end
    
    it "should be able to create an empty Atom object" do
      entry = Restfulie::Common::Representation::Atom::Entry.new
      entry.id = "new_id"
      entry.title = "new title"
      a_time = Time.now
      entry.updated = a_time
      
      entry.id.should == "new_id"
      entry.title.should == "new title"
      entry.updated.should be_kind_of(Time)
      entry.updated.should == Time.parse(a_time.to_s)
    end
  end
  
  describe "Feed read" do
    
    it "should access required attributes" do
      @atom.id.should == "http://example.com/albums/1"
      @atom.title.should == "Albums feed"
      @atom.updated.should be_kind_of(Time)
      @atom.updated.should == Time.parse("2010-05-03T16:29:26-03:00")
    end

    it "should access recommended attributes" do
      @atom.authors.size.should == 2
      @atom.authors.first.name.should == "John Doe"
      @atom.authors.first.email.should == "joedoe@example.com"
      
      @atom.links.size.should == 2
      @atom.links.first.rel.should == "self"
      @atom.links.first.href.should == "http://example.com/albums/1"
      
      @atom.links.alternate.href.should == "http://example.com/albums/1/csv"
      @atom.links.alternate.type.should == "text/csv"
    end
    
    it "should support access to feed extensions" do
      @atom.extensions.size.should == 1
      @atom.extensions.first.class.should == Nokogiri::XML::Element
      @atom.extensions.first.content.to_i.should == 2
    end
    
    it "should access entries as array" do
      @atom.entries.size.should == 2
      @atom.entries.first.id.should == "uri:1"
      @atom.entries.first.title.should == "Article 1"
      
      @atom.entries.first.links.image.first.href.should == "http://example.com/image/1"
      @atom.entries.first.links.unknow_rel.should == nil
    end
    
  end
  
  describe "Feed write" do
    
    it "should write required attributes" do
      @atom.id = "new_id"
      @atom.title = "new title"
      a_time = Time.now
      @atom.updated = a_time
      @atom.logo = "logo.jpg"
      
      @atom.id.should == "new_id"
      @atom.title.should == "new title"
      @atom.updated.should be_kind_of(Time)
      @atom.updated.should == Time.parse(a_time.to_s)
      @atom.logo.should == "logo.jpg"
    end
  
    it "should write recommended attributes" do      
      an_author = Restfulie::Common::Representation::Atom::Person.new("author", :name => "Trololo", :email => "trololo@tro.com")
      @atom.authors << an_author
      @atom.authors.size.should == 3
      @atom.authors.last.name.should == "Trololo"
      @atom.authors.last.email = "foobar@foo.com"
      @atom.authors.last.email.should == "foobar@foo.com"
      
      @atom.links.size.should == 2
      a_link = @atom.links.first
      a_link.rel.should == "self"
      a_link.href.should == "http://example.com/albums/1"
      
      @atom.links << Restfulie::Common::Representation::Atom::Link.new(:href => "http://example.com/albums/2", :rel => "alternate")
      @atom.links.size.should == 3
      
      @atom.links.delete(a_link)
      @atom.links.size.should == 2
    end
    
  end
  
  describe "Entry read" do
    
    it "should access required attributes" do
      entry = @atom.entries.first
      
      entry.id.should == "uri:1"
      entry.title.should == "Article 1"
      entry.updated.should be_kind_of(Time)
      entry.updated.should == Time.parse("2010-05-03T16:29:26-03:00")
    end

    it "should access recommended attributes" do
      entry = @atom.entries.first
      
      entry.authors.size.should == 1
      entry.authors.first.name.should == "Foo Bar"
      entry.authors.first.email.should == "foobar@example.com"
      
      entry.links.size.should == 2
      entry.links.first.rel.should == "image"
      entry.links.first.href.should == "http://example.com/image/1"
      
      entry.summary.should == "Some text."
      entry.content.should == 'a freaking awesome content'
    end
    
    it "should support access to entry extensions" do
      entry = @atom.entries.first

      entry.extensions.size.should == 1
      entry.extensions.first.class.should == Nokogiri::XML::Element
      entry.extensions.first.at_xpath("xmlns:editor", "xmlns" => "http://article.namespace.com")["name"].should == "foozine"
    end
    
  end
  
  
end
