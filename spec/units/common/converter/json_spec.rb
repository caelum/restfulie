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
  describe 'JSON' do

    describe "Collection" do
      
      it "should create a collection from builder DSL" do
        time = Time.now
        some_articles = [
          {:id => 1, :title => "a great article", :updated => time},
          {:id => 2, :title => "another great article", :updated => time}
        ]
        
        json = to_json(some_articles) do |collection|
          collection.values do |values|
            values.id      "http://example.com/json"
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
          
          collection.members(:name => "articles") do |member, article|
            member.values do |values|
              values.id      "uri:#{article[:id]}"                   
              values.title   article[:title]
              values.updated article[:updated]              
            end
            
            member.link("image", "http://example.com/image/1")
            member.link("image", "http://example.com/image/2", :type => "application/json")
          end
        end

        json.id.should == "http://example.com/json"
        json.title.should == "Feed"
        json.updated.should == time
        json.author.first.name.should == "John Doe"
        json.author.last.email.should == "foobar@example.com"
        
        json.articles.first.id.should == "uri:1"
        json.articles.first.title.should == "a great article"
    end
     
    it "should create a collection from a string input" do
      full_json = IO.read(File.dirname(__FILE__) + '/../../lib/jsons/full_json.js')
      json = to_json(full_json)

      json["articles"]["size"].should  == 2
      json["articles"]["freezed"].should == nil
      
      json.articles.__free_method__(:size).size.should  == 2
      json.articles.freezed.should == nil    end
  end

    describe "Member" do
      
      it "should create a member from builder DSL" do
        time = Time.now
        an_article = {:id => 1, :title => "a great article", :updated => time}
        
        entry = to_json(an_article, :atom_type => :entry) do |member, article|
          member.values do |values|
            values.id      "uri:#{article[:id]}"                   
            values.title   article[:title]
            values.updated article[:updated]
          end
          
          member.link("image", "http://example.com/image/1")
          member.link("image", "http://example.com/image/2", :type => "application/json")                                
        end
        
        entry.id.should == "uri:1"
        entry.title.should == "a great article"
        entry.updated.should == time
      end
    
      it "should be able to declare links inside values block" do
        time = Time.now
        an_article = {:id => 1, :title => "a great article", :updated => time}
    
        entry = to_json(an_article, :atom_type => :entry) do |member, article|
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
    
        entry.id.should == "uri:1"
        entry.title.should == "a great article"
        entry.updated.should == time
        
        entry.domain.link.first.rel.should == "image"
      end
      
      it "should create a member from an already declared recipe" do
       
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
        
        entry = to_json(an_article, :recipe => :simple_entry)
                
        entry.id.should == "uri:1"
        entry.title.should == "a great article"
        entry.updated.should == time
      end
    
    end

    describe "Errors" do
      it "should raise error for converter without recipe" do
        lambda {
          to_json
        }.should raise_error(Restfulie::Common::Error::ConverterError, "Recipe required")
      end
      
    end

  end

  def to_json(*args, &recipe)
    Restfulie::Common::Converter::Json.to_json(*args, &recipe)
  end

  def describe_recipe(*args, &recipe)
    Restfulie::Common::Converter::Json.describe_recipe(*args, &recipe)
  end
  
  def simple_object(*args)
    Restfulie::Common::Converter::Test::SimpleClass.new(*args)
  end

end
