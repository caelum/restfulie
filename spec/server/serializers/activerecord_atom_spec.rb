require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../libs/models')

ActionController::Routing::Routes.draw do |map|
  map.resources :albums do |album|
    album.resources :songs, :controller => 'albums/songs', :format => :xml
  end
  map.resources :songs
end

describe Restfulie::Server::Serializers::ActiveRecord::Atom do
  
  before(:all) do
    @song = Song.first
    @album = Album.first
  end
  
  it "accepts an ActiveRecord model and keeps it" do
    atom_serializer = Restfulie::Server::Serializers::ActiveRecord::Atom.new(@song)
    atom_serializer.record == @song
  end
  
  context "when building Atom::Entry" do
    
    context "for Song" do
      before(:all) do
        @song_atomified = @song.to_atom
      end
    
      context "with atom:link" do
        before(:all) do
          @links = @song_atomified.links
        end
    
        it "generates link for self" do
          @links.map(&:rel).should  include(:self)
          @links.map(&:href).should include("http://localhost:3000/songs/1")
        end
        
        it "generates link for internal relationship" do
          @links.map(&:rel).should  include(:album)
          @links.map(&:href).should include("http://localhost:3000/albums/1")
        end
      end
      
      context "with attributes" do
        it "generates default attributes" do
          @song_atomified.title.should_not      be_nil
          @song_atomified.id.should_not         be_nil
          @song_atomified.published.should_not  be_nil
          @song_atomified.updated.should_not    be_nil
        end
        
        it "register model class as an Atom namespace" do
          ::Atom::Entry.known_namespaces.should include "urn:song"
        end
        
        it "register model's attribute description in Atom::Entry" do
          ::Atom::Entry.element_specs.should have_key "description"
          ::Atom::Entry.element_specs["description"].name.should == "song:description"
          ::Atom::Entry.element_specs["description"].options[:type].should == :single
          ::Atom::Entry.element_specs["description"].attribute.should == "song_description"
        end
      end
    end
  end
  
  context "for Album" do
    before(:all) do
      @album_atomified = @album.to_atom
    end
    
    context "with atom:link" do
      it "generates link for self" do
        @album_atomified.links.map(&:rel).should  include(:self)
        @album_atomified.links.map(&:href).should include("http://localhost:3000/albums/1")  
      end
      
      it "generates link for :has_many songs" do
        @album_atomified.links.map(&:rel).should include(:songs)
        @album_atomified.links.map(&:href).should include("http://localhost:3000/albums/1/songs")
      end
    end
    
    context "with attributes" do
      it "generates default attributes" do
        @album_atomified.title.should_not      be_nil
        @album_atomified.id.should_not         be_nil
        @album_atomified.published.should_not  be_nil
        @album_atomified.updated.should_not    be_nil
      end
      
      it "register model class as an Atom namespace" do
        ::Atom::Entry.known_namespaces.should include "urn:album"
      end
      
      it "register model's attribute description in Atom::Entry" do
        ::Atom::Entry.element_specs.should have_key "description"
        ::Atom::Entry.element_specs["description"].name.should == "album:description"
        ::Atom::Entry.element_specs["description"].options[:type].should == :single
        ::Atom::Entry.element_specs["description"].attribute.should == "album_description"
      end
    end    
  end
end