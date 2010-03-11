require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../data/data_helper')
require File.expand_path(File.dirname(__FILE__) + '/../lib/compare_atoms.rb')

ActionController::Routing::Routes.draw do |map|
  map.resources :albums do |album|
    album.resources :songs, :controller => 'albums/songs', :format => :xml
  end
  map.resources :songs
end

context "builder representations" do
  include Restfulie::Builder::Helpers
  
  context "marshalling atom" do
    context "for member" do
      before do
        dt     = DateTime.parse("2010-03-10T14:32:01-03:00")
        @album = Album.first
        @album.attributes = {:title => nil, :created_at => dt, :updated_at => dt}
      end
      
      it "generates basic representation for member" do
        builder  = describe_member(@album)
        atom_xml = builder.to_atom
        original_entry = Atom::Entry.load_entry(atom_xml)
        original_entry.should be_eql_xml(load_data("atoms", "basic_member.xml"))
      end
    end # context "for member"

    context "for collection" do

    end # context "for member"
    
  end # context "marshalling atom"
end # context "marshalling representations"