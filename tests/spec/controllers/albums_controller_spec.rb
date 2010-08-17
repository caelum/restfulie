require 'spec_helper'

describe AlbumsController do
  
  before do
    3.times do |i|
      album = Album.create!(:title => "Album #{i}", :description => "Description #{i}", :length => i*10)
      4.times do |j|
        album.songs.create!(:title => "Song #{j} from Album #{i}", :description => "Description for song #{j} from Album #{i}", :length => j*10 + i)
      end
    end
  end

  render_views
  
  describe "get index" do
    before do
      request.accept = "application/atom+xml"
      response.stub (:content_type) { "application/atom+xml" }
      get :index, :format => :atom
      @feed = Restfulie::Common::Representation::Atom::Factory.create(response.body)
    end
    
    it "generation atom feed to get index" do
      @feed.entries.size.should == Album.count
    end
    
    it "title feed personalize" do
      @feed.title.should == "Index Album feed spec"
    end
    
    it "members artists transitions included" do
      transitions = @feed.entries.first.links
      transitions.find {|t| t.rel == 'artists'}.should be_kind_of(::Restfulie::Common::Representation::Atom::Link)
    end
  end # describe "get index"
  
  describe "get show" do
    before do
      response.content_type = "application/atom+xml"
      @album = Album.first
      get :show, :id => @album.id, :format => :atom
      @entry = Restfulie::Common::Representation::Atom::Factory.create(response.body)      
    end
  
    it "generation atom entry" do
      @entry.title.should == @album.title
    end
  
    it "return extension values" do
      @entry.doc.at_xpath("albums:length_in_minutes", "albums" => "http://localhost/albums").content.to_i.should == @album.length
      @entry.doc.at_xpath("albums:description", "albums" => "http://localhost/albums").content.should == @album.description
    end
  end # describe "get show"
  
end
