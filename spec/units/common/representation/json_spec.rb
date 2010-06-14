require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'json'

context Restfulie::Common::Representation::Json do
  
  before :all do
    full_json = IO.read(File.dirname(__FILE__) + '/../../lib/jsons/full_json.js')
    @json = Restfulie::Common::Representation::Json.create(full_json)
  end
  
  describe "JSON creation" do
  
    it "should be able to create an empty JSON object" do
      json = Restfulie::Common::Representation::Json.create
      json["id"] = "new_id"
      json["title"] = "new title"
      a_time = Time.now
      json.updated = a_time
      
      json["id"].should == "new_id"
      json["title"].should == "new title"
      json.updated.should == a_time     
      
      json.to_s.class.should == String
    end
  end
  
  describe "JSON read" do
    
    it "should be able to read a JSON object in many ways" do
      @json["articles"]["size"].should  == 2
      @json["articles"]["freezed"].should == nil
      
      @json.articles.__free_method__(:size).size.should  == 2
      @json.articles.freezed.should == nil
  
      # the old methods are still available. eg: the number of keys in articles Hash 
      @json.articles.__size__.should == 4
      
      @json["articles"]["link"].first["type"].should == "text/json"
      @json.articles.link.first.type.should == "text/json"

      # accessing using JsonLinkCollection
      @json.articles.links.search.href.should == "http://search.place.com"
      @json.articles.links.unknow_rel.should == nil
    end
    
  end
  
  describe "JSON write" do
    
    it "should be able to write a JSON object in many ways" do
      @json["articles"]["size"] = 10
      @json["articles"]["size"].should  == 10
  
      # previously freed methods are kept free in the object
      @json.articles.size = 15
      @json.articles.__free_method__(:size).size.should  == 15
      
      @json.articles.link << {"href" => "http://dont.panic.com", "rel" => "towel"}
      @json.articles.link.last.href.should == "http://dont.panic.com"
      @json.articles.link.last.rel.should  == "towel"
      @json.articles.link.size.should == 3
      
      @json.articles.link.last.type = "application/json"
      @json.articles.link.last.type.should  == "application/json"
    end
    
  end
  
end