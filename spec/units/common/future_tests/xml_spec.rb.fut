require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/models')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/routes')

context "builder representations" do
  include Restfulie::Common::Builder::Helpers
  include ActionController::UrlWriter
  
  default_url_options[:host] = 'localhost'

  context "marshalling xml" do
    context "for member" do
      before do
        @album = Album.first
      end
      
      it "infer values from basic member describe and generation" do
        builder  = describe_member(@album)
        entry    = Hash.from_xml(builder.to_xml)
        entry["album"]["id"].should == @album.id.to_s
        entry["album"]["title"].should == @album.title
        entry["album"]["updated_at"].should == @album.updated_at.to_s
      end
      
      it "allow custom values" do
      
        builder  = describe_member(@album) do |member|
          member.double_id = @album.id*2
        end
      
        entry    = Hash.from_xml(builder.to_xml)
        entry["album"]["double_id"].should == (@album.id*2).to_s
      end
      
      context "with custom namespace" do
        it "should eager load all fields" do
          builder = describe_member(@album, :namespace => "http://example.com/albums")
          
          entry    = Hash.from_xml(builder.to_xml)
          entry["album"]["id"].should == @album.id.to_s
          entry["album"]["title"].should == @album.title
          entry["album"]["updated_at"].should == @album.updated_at.to_s
        end
        
        it "should allow extra namespace parameters" do
          builder = describe_member(@album, :namespace => "http://example.com/albums") do |member|
            member.namespace(:albums) do |ns|
              ns.composer = "chemical brothers"
            end
          end
          
          entry    = Hash.from_xml(builder.to_xml)
          entry["album"]["composer"].should == "chemical brothers"
        end
      end
      
      context "transitions" do
        
        it "should infer the url of the transitions" do
          builder  = describe_member(@album) do |member|
            member.links << link(:self)
            member.links << link(:songs)
          end

          entry    = Hash.from_xml(builder.to_xml)
          link_for(entry, "self")["href"].should == album_url(@album)
          link_for(entry, "songs")["href"].should == album_songs_url(@album)
        end
        
        it "custom transitions" do
          builder  = describe_member(@album, :eagerload => [:transitions]) do |member|
            member.links.delete(:songs)
            member.links << link(:songs)
            
            member.links << link(:rel => :artist, :href => "http://localhost/albums/1/artist")
            member.links << link(:rel => 'lyrics', :href => "http://localhost/albums/1/lyrics")
          end
          
          entry    = Hash.from_xml(builder.to_xml)
          ["artist", "lyrics"].each do |l|
            found = link_for(entry, l)
            found["href"].should == "http://localhost/albums/1/#{l}"
          end
          link_for(entry, "songs")["href"].should == album_songs_url(@album)
        end
        
        def link_for(entry, rel)
          entry["album"]["link"].find do |found|
            found["rel"]==rel
          end
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

  end # context "marshalling xml"
  
  def create_atom_link(rel, href, type = "application/atom+xml")
    Atom::Link.new(:rel => rel, :href => href, :type => type)
  end
end # context "marshalling representations"



--------------------------------------------------------------------------------------------------


require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Hash do
  before do
    @hash = {"name" => "Guilherme Silveira", "link" => ["rel" => "start"]}
  end
  context "when requesting its links" do
    it "should return all links if there is more than one" do
      @hash["link"] << ["rel" => "end"]
      @hash.links.size.should == 2
    end
    it "should return the only link within an array" do
      @hash.links.size.should == 1
    end
    it "should return empty array if there are no links" do
      @hash.delete("link")
      @hash.links.should == []
    end
    it "should return the selected link if one is requested" do
      @hash.links("start").should be_kind_of(Restfulie::Client::Link)
    end
    it "should return nil if no link is available" do
      @hash.links("end").should be_nil
    end
  end
  context "when retrieving a value" do
    it "should return its value when invoking a method which key is contained" do
      @hash.name.should == "Guilherme Silveira"
    end
    it "should return true when respond_to? a key name" do
      @hash.should respond_to(:name)
      @hash.should respond_to("name")
    end
  end
end

context Restfulie::Common::Representation::XmlD do
  
  context "when unmarshalling" do
    it "should unmarshall an entry" do
      result = Restfulie::Common::Representation::XmlD.new.unmarshal('<root><entry></entry></root>')
      result.should respond_to "entry"
      result.should be_kind_of(Hash)
    end
  end
  context "when marshalling" do

    it "should return itself if its a string" do
      result = Restfulie::Common::Representation::XmlD.new.marshal("content", "")
      result.should == "content"
    end
    it "should serialize if its anything else" do
      hash = {"name" => "value"}
      result = Restfulie::Common::Representation::XmlD.new.marshal(hash, "")
      result.should == hash.to_xml
    end
  end
  
end


--------------------------------------------------------------------------------------------------




