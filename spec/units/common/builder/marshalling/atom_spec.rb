require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/models')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/routes')

context "builder representations" do
  include Restfulie::Common::Builder::Helpers
  include ActionController::UrlWriter
  
  default_url_options[:host] = 'localhost'

  context "marshalling atom" do
    context "for member" do
      before do
        @album = Album.first
      end
      
      it "infer atom values from basic member describe and generation" do
        builder  = describe_member(@album)
        entry    = Atom::Entry.load_entry(builder.to_atom)
        entry.id.should == album_url(@album)
        entry.title.should == @album.title
        entry.updated.should == @album.updated_at
      end
      
      it "set atom values from and generation" do
        id      = "http://localhost/rest/albums/#{@album.id}"
        title   = "Album title"
        updated = DateTime.parse(DateTime.now.to_s)
      
        builder  = describe_member(@album) do |member|
          member.id    = id
          member.title = title
          member.updated = updated
        end
      
        entry = Atom::Entry.load_entry(builder.to_atom)
        entry.id.should == id
        entry.title.should == title
        entry.updated.should == updated
      end
      
      it "whit values in params" do
        updated = DateTime.parse(DateTime.now.to_s)
        builder = describe_member(@album, :values => { :updated => updated })
      
        entry = Atom::Entry.load_entry(builder.to_atom)
        entry.updated.should == updated
      end
      
      it "raiser error invalid value information" do
        lambda {
          (describe_member(@album, :values => { :foobar => Time.now })).to_atom
        }.should raise_error(Restfulie::Common::Error::AtomMarshallingError, 'Attribute foobar unsupported in Atom Entry.')
      end
      
      context "namespace personalize" do
        it "with eager load" do
          builder = describe_member(@album, :namespace => "http://example.com/albums")
          
          entry = Atom::Entry.load_entry(builder.to_atom)
          entry.albums_length.to_i.should == @album.length
          entry.albums_description.should == @album.description
        end
        
        it "with eager load and set more values" do
          builder = describe_member(@album, :namespace => "http://example.com/albums") do |member|
            member.namespace(:albums) do |ns|
              ns.composer = "Composer Name"
            end
          end
          
          entry = Atom::Entry.load_entry(builder.to_atom)
          entry.albums_description.should == @album.description
          entry.albums_composer.should == "Composer Name"
        end
      end
      
      context "transitions" do
        
        it "infers the url of the transitions" do
          builder  = describe_member(@album) do |member|
            member.links << link(:self)
            member.links << link(:songs)
          end
          
          entry = Atom::Entry.load_entry(builder.to_atom)
          entry.links.should be_include(create_atom_link('self', album_url(@album)))
          entry.links.should be_include(create_atom_link('songs', album_songs_url(@album)))
        end
        
        it "custom transitions" do
          builder  = describe_member(@album, :eagerload => [:transitions]) do |member|
            member.links.delete(:songs)
            member.links << link(:songs)
            
            member.links << link(:rel => :artist, :href => "http://localhost/albums/1/artist", :type => "application/atom+xml")
            member.links << link(:rel => 'lyrics', :href => "http://localhost/albums/1/lyrics", :type => "application/atom+xml")
          end
          
          entry = Atom::Entry.load_entry(builder.to_atom)
          entry.links.should be_include(create_atom_link('songs' , album_songs_url(@album)))
          entry.links.should be_include(create_atom_link('artist', "http://localhost/albums/1/artist"))
          entry.links.should be_include(create_atom_link('lyrics', "http://localhost/albums/1/lyrics"))
        end
      end
      
    end # context "for member"

    context "for collection" do

      before do
        @albums = Album.all
      end
      
      it "infer atom values from basic collection describe and generation" do
        builder = describe_collection(@albums, :values => { :id => "http://localhost/albums" })
        feed    = Atom::Feed.load_feed(builder.to_atom)
        feed.id.should == "http://localhost/albums"
        feed.title.should == "Albums feed"
        feed.entries.size.should == @albums.size
        feed.entries.first.title == @albums.first.title
      end
      
      it "generate representation songs with belongs_to association" do
        @album = @albums.first
        @songs = @album.songs
        
        builder = describe_collection(@songs, :self => album_songs_url(@album))
        
        feed = Atom::Feed.load_feed(builder.to_atom)
        feed.links.should be_include(create_atom_link('self', album_songs_url(@album)))
      end
      
      it "with namespace" do
        builder = describe_collection(@albums, :values => { :id => "http://localhost/albums" }) do |collection|
          collection.namespace(:albums, "http://localhost/albums") do |ns|
            ns.count = 10
          end
        end
        
        feed = Atom::Feed.load_feed(builder.to_atom)
        feed.albums_count.to_i.should == 10
      end
      
      it "customize members" do
        builder = describe_collection(@albums, :values => { :id => "http://localhost/albums" }) do |collection|
          collection.describe_members(:namespace => "http://example.com/albums") do |member, album|
            member.links << link(:self)
            member.links << link(:rel => :artists, :href => "http://localhost/albums/#{album.id}/artists", :type => "application/atom+xml")
    
            member.namespace(:music, "http://localhost/musics") do |ns|
              ns.count = 3
            end
          end
        end
        
        feed = Atom::Feed.load_feed(builder.to_atom)
        album = @albums.first
        entry = feed.entries.first
        entry.links.should be_include(create_atom_link('self', album_url(album)))
        entry.links.should be_include(create_atom_link('artists', "http://localhost/albums/#{album.id}/artists"))
        entry.albums_length == album.length
        entry.albums_description == album.description
        entry.music_count.to_i.should == 3
      end

      it "generate full representation" do
        options = {
          :self => "http://localhost/albums",
          :values => { :id => "http://localhost/albums" }
        }
        
        builder = describe_collection(@albums, options) do |collection|
          collection.links << link(:rel => :next, :href => "http://localhost/albums/next")
      
          collection.namespace(:albums, "http://localhost/albums") do |ns|
            ns.count = 10
          end
      
          collection.describe_members(:namespace => "http://example.com/albums") do |member, album|
            member.links << link(:rel => :artists, :href => "http://localhost/albums/#{album.id}/artists", :type => "application/atom+xml")
      
            member.namespace(:music, "http://localhost/musics") do |ns|
              ns.count = 3
            end
          end
        end
        feed = Atom::Feed.load_feed(builder.to_atom)
        feed.should be_kind_of(Atom::Feed)
      end
    end # context "for member"

  end # context "marshalling atom"
  
  def create_atom_link(rel, href, type = "application/atom+xml")
    Atom::Link.new(:rel => rel, :href => href, :type => type)
  end
end # context "marshalling representations"