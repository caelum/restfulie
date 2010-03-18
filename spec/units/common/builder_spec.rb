require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../lib/models')
require File.expand_path(File.dirname(__FILE__) + '/../data/data_helper')
require File.expand_path(File.dirname(__FILE__) + '/../lib/compare_atoms')
require File.expand_path(File.dirname(__FILE__) + '/../lib/routes')

context "builder representations" do
  include Restfulie::Common::Builder::Helpers
  include ActionController::UrlWriter

  context "marshalling atom" do
    context "for member" do
      before do
        dt     = DateTime.parse("2010-03-10T14:32:01-03:00")
        @album = Album.first
        @album.attributes = {:title => nil, :created_at => dt, :updated_at => dt, :length => 60, :description => "Album description"}
      end
      
      context "generate basic representation" do
        it "without eagerload" do 
          builder  = describe_member(@album, :eagerload => false)
          original_entry = Atom::Entry.load_entry(builder.to_atom)
          original_entry.should be_eql_xml(load_data("atoms/member", "basic_member.xml"))
        end
        
        it "with eagerload values" do
          builder  = describe_member(@album, :eagerload => [:values])
          original_entry = Atom::Entry.load_entry(builder.to_atom)
          original_entry.should be_eql_xml(load_data("atoms/member", "with_values.xml"))
        end
        
        it "with eagerload values and custom values" do
          builder  = describe_member(@album, :eagerload => [:values]) do |member|
            member.namespace(:album) do |ns|
              ns.composer = "Composer Name"
            end
          end

          original_entry = Atom::Entry.load_entry(builder.to_atom)
          original_entry.should be_eql_xml(load_data("atoms/member", "with_values_and_custom_values.xml"))
        end
        
        it "with eagerload transitions" do
          builder  = describe_member(@album, :eagerload => [:transitions]) do |member|
            member.links.delete(:songs)
            member.links << link(:songs)
          end
          original_entry = Atom::Entry.load_entry(builder.to_atom)
          original_entry.should be_eql_xml(load_data("atoms/member", "eagerload_transitions.xml"))
        end
        
        it "with eagerload transitions and custom transitions" do
          builder  = describe_member(@album, :eagerload => [:transitions]) do |member|
            member.links.delete(:songs)
            member.links << link(:songs)
            
            member.links << link(:rel => :artist, :href => "http://localhost/albums/1/artist", :type => "application/atom+xml")
            member.links << link(:rel => :lyrics, :href => "http://localhost/albums/1/lyrics", :type => "application/atom+xml")
          end
          original_entry = Atom::Entry.load_entry(builder.to_atom)
          original_entry.should be_eql_xml(load_data("atoms/member", "eagerload_and_custom_transitions.xml"))
        end
        
      end # context "generate basic representation"
      
    end # context "for member"

    context "for collection" do

      before do
        dt      = DateTime.parse("2010-03-10T14:32:01-03:00")
        @albums = Album.find(:all, :limit => 3)
        @albums.each do |album|
          album.attributes = {:title => nil, :created_at => dt, :updated_at => dt, :length => 60, :description => "Album description"}
        end
      end

      it "generate basic representation" do
        builder = describe_collection(@albums, :eagerload => false, :values => { :id => "http://localhost/albums" })
        original_entry = Atom::Feed.load_feed(builder.to_atom)
        original_entry.should be_eql_xml(load_data("atoms/collection", "basic_collection.xml"))
      end
      
      it "generate full representation" do
        options = {
          :eagerload => true,
          :self => "http://localhost/albums",
          :values => { :id => "http://localhost/albums" }
        }
        builder = describe_collection(@albums, options) do |collection|
          collection.links << link(:rel => :next, :href => "http://localhost/albums/next")
          
          collection.namespace(:albums, "http://localhost/albums") do |ns|
            ns.count = 10
          end

          collection.describe_members do |member, album|
            member.links << link(:rel => :artists, :href => "http://localhost/albums/#{album.id}/artists", :type => "application/atom+xml")

            member.namespace(:music, "http://localhost/musics") do |ns|
              ns.count = 3
            end
          end
        end
        original_entry = Atom::Feed.load_feed(builder.to_atom)
        original_entry.should be_eql_xml(load_data("atoms/collection", "full_collection.xml"))
      end
    end # context "for member"

  end # context "marshalling atom"
end # context "marshalling representations"