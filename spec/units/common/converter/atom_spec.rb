require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/models')

module Restfulie::Common::Converter::Test
  class SimpleClass
    attr_accessor :id, :title, :updated
    def initialize(id,title,updated)
      @id, @title, @updated = id, title, updated
    end
  end
end

describe Restfulie::Common::Converter do
  describe 'Atom' do

    describe "Feed" do
      it "should create a feed from builder DSL" do
        time = Time.now
        some_articles = [
          {:id => 1, :title => "a great article", :updated => time},
          {:id => 2, :title => "another great article", :updated => time}
        ]
        
        feed = to_atom(some_articles) do |collection|
          collection.values do |values|
            values.id      "http://example.com/feed"
            values.title   "Feed"
            values.updated time

            values.author { 
              values.name  "John Doe"
              values.email "joedoe@example.com"
            }
            
            values.author { 
              values.name  "Foo Bar"
              values.email "foobar@example.com"
            }
          end
          
          collection.link("next", "http://a.link.com/next")
          collection.link("previous", "http://a.link.com/previous")
          
          collection.members do |member, article|
            member.values do |values|
              values.id      "uri:#{article[:id]}"                   
              values.title   article[:title]
              values.updated article[:updated]
            end
            
            member.link("image", "http://example.com/image/1")
            member.link("image", "http://example.com/image/2", :type => "application/atom+xml")                                
          end
        end
        
        # puts feed.to_xml
        
        feed.atom_type.should == "feed"
        feed.id.should == "http://example.com/feed"
        feed.title.should == "Feed"
        feed.updated.should == DateTime.parse(time.xmlschema)
        feed.authors.first.name.should == "John Doe"
        feed.authors.last.email.should == "foobar@example.com"
        
        feed.entries.first.id.should == "uri:1"
        feed.entries.first.title.should == "a great article"
     end

    end

    describe "Entry" do
      it "should create an entry from builder DSL" do
        time = Time.now
        an_article = {:id => 1, :title => "a great article", :updated => time}
        
        entry = to_atom(an_article, :atom_type => :entry) do |member, article|
          member.values do |values|
            values.id      "uri:#{article[:id]}"                   
            values.title   article[:title]
            values.updated article[:updated]
          end
          
          member.link("image", "http://example.com/image/1")
          member.link("image", "http://example.com/image/2", :type => "application/atom+xml")                                
        end
        
        # puts entry.to_xml
        
        entry.atom_type.should == "entry"
        entry.id.should == "uri:1"
        entry.title.should == "a great article"
        entry.updated.should == DateTime.parse(time.xmlschema)
      end

      it "should be able to declare links inside values block" do
        time = Time.now
        an_article = {:id => 1, :title => "a great article", :updated => time}

        entry = to_atom(an_article, :atom_type => :entry) do |member, article|
          member.values do |values|
            values.id      "uri:#{article[:id]}"                   
            values.title   article[:title]
            values.updated article[:updated]
            
            values.domain("xmlns" => "http://a.namespace.com") {
              member.link("image", "http://example.com/image/1")
              member.link("image", "http://example.com/image/2", :type => "application/atom+xml")
            }
          end
        end

        #puts entry.to_xml
        entry.atom_type.should == "entry"
        entry.id.should == "uri:1"
        entry.title.should == "a great article"
        entry.updated.should == DateTime.parse(time.xmlschema)
        
        entry.doc.xpath("xmlns:domain", "xmlns" => "http://a.namespace.com").children.first.node_name.should == "link"
      end
      
      it "should create an entry from an already declared recipe" do
       
        describe_recipe(:simple_entry) do |member, article|
          member.values do |values|
            values.id      "uri:#{article[:id]}"                   
            values.title   article[:title]
            values.updated article[:updated]
          end
          
          member.link("image", "http://example.com/image/1")
          member.link("image", "http://example.com/image/2", :type => "application/atom+xml")                                
        end
       
        time = Time.now
        an_article = {:id => 1, :title => "a great article", :updated => time}
        
        entry = to_atom(an_article, :atom_type => :entry, :recipe => :simple_entry)
        
        #puts entry.to_xml
        
        entry.atom_type.should == "entry"
        entry.id.should == "uri:1"
        entry.title.should == "a great article"
        entry.updated.should == DateTime.parse(time.xmlschema)
      end
    
    end

    #describe 'Custom Convertion' do
      #before do
        #@obj = Restfulie::Common::Converter::Test::SimpleClass.new('id','title',DateTime.parse(DateTime.now.to_s))
      #end

      #it 'should convert simple class to atom representation' do
        #describe_recipe(:id_recipe) do |representation, obj|
          #representation.id = obj.id
        #end

        #describe_recipe(:title_recipe) do |representation, obj|
          #representation.title = "#{obj.title}/#{obj.id}"
        #end

        #feed = to_atom(@obj, :recipes => [:id_recipe, :title_recipe]) do |representation, obj|
          #representation.links << Restfulie::Common::Converter::Atom.link(:href => 'http://localhost', :rel => :self)
        #end

        #feed.id.should == @obj.id
        #feed.title.should == "#{@obj.title}/#{@obj.id}"
        #feed.updated.year.should == @obj.updated.year
        #link = feed.links.first
        #link.href.should == 'http://localhost'
        #link.rel.should == :self
      #end

      #it "should convert with recipe block" do
        #feed = Restfulie::Common::Converter::Atom.to_atom(@obj) do |representation, obj|
          #representation.id      = obj.id
          #representation.title   = "#{obj.title}/#{obj.id}"
          #representation.updated = obj.updated
          #representation.links   << Restfulie::Common::Converter::Atom.link(:href => 'http://localhost', :rel => :self)
        #end
        
        #feed.id.should == @obj.id
        #feed.title.should == "#{@obj.title}/#{@obj.id}"
        #feed.updated.year.should == @obj.updated.year
        #link = feed.links.first
        #link.href.should == 'http://localhost'
        #link.rel.should == :self
      #end
      
    #end

    describe "Errors" do
      it "should raise error for converter without recipe" do
        lambda {
          to_atom
        }.should raise_error(Restfulie::Common::Error::ConverterError, "Recipe required")
      end
      
      it "raiser error to invalid atom type" do
        lambda {
          obj = Object.new
          Restfulie::Common::Converter::Atom.to_atom(obj, :atom_type => :foo)
        }.should raise_error(Restfulie::Common::Error::ConverterError, "Undefined atom type foo")
      end
    end

  end

  def to_atom(*args, &recipe)
    Restfulie::Common::Converter::Atom.to_atom(*args, &recipe)
  end

  def describe_recipe(*args, &recipe)
    Restfulie::Common::Converter::Atom.describe_recipe(*args, &recipe)
  end
  
  def simple_object(*args)
    Restfulie::Common::Converter::Test::SimpleClass.new(*args)
  end

end
