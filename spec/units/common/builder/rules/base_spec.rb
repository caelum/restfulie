require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

context Restfulie::Common::Builder::Rules::Base do
  it "should respond to links and links is a collection" do
    @rule = create_rule
    @rule.should respond_to(:links)
    (@rule.links << create_link(:self)).should_not be_nil
  end
  
  it "should respond to blocks and links is a collection" do
    block_one = lambda {}
    block_two = lambda {}
    @rule = create_rule([block_two], &block_one)
    
    @rule.should respond_to(:blocks)
    @rule.blocks.should be_include(block_one)
    @rule.blocks.should be_include(block_two)
    (@rule.blocks << lambda {}).should_not be_nil
  end

  it "should respond to apply" do
    class Foo; attr_accessor :name; end

    @rule = create_rule do |rule, object|
      rule.links << create_link(:self)
      object.name = "Foo object"
    end

    foo = Foo.new()
    @rule.links.should be_blank
    @rule.apply(foo)
    @rule.links.size.should eql(1)
    foo.name.should == "Foo object"
  end

  it "should respond to apply with variable arity in block" do
    @rule = create_rule {|rule, object|}
    @rule.apply(Object.new).should == @rule.blocks
    @rule.apply(Object.new, Object.new).should == @rule.blocks
  end

  context "namespace helper" do
    module RulesBaseSpec
      class Album
        attr_accessor :composer
        attr_accessor :title

        def initialize(data)
          data.each { |k, v| self.send("#{k}=".to_sym, v) }
        end
      end
    end
    
    before do
      @rule  = create_rule()
      @album_data = { :composer => "Designer Drugs", :title => "Album title" }
      @album = RulesBaseSpec::Album.new(@album_data)
      @uri   = "http://albums.example.com"
    end

    it "should create a new namespace" do
      ns = @rule.namespace(:album, @uri) do |ns|
        ns.composer = @album.composer
      end
      ns.composer.should == @album.composer
    end
    
    context "eager load" do
      it "load based in intance_variables" do
        ns = @rule.namespace(@album, @uri)
        ns.namespace.should == :albums
        ns.title.should     == @album.title
        ns.composer.should  == @album.composer
      end
      
      it "load based in method attributes" do
        def @album.attributes
          { :title => @title, :composer => nil }
        end
        
        ns = @rule.namespace(@album, @uri)
        ns.title.should     == @album.title
        ns.composer.should  == nil
      end
      
      it "update a namespace" do
        @rule.namespace(@album, @uri)
        ns = @rule.namespace(:albums) do |ns|
          ns.delete(:title)
          ns.composer = nil
        end
        ns.keys.should == [:composer]
        ns.composer.should  == nil
      end
      
      it "hash load supported" do
        ns = @rule.namespace(:albums, @uri, :eager_load => @album_data)
        ns.namespace.should == :albums
        ns.title.should == @album_data[:title]
        ns.composer.should == @album_data[:composer]
      end
      
      it "dont load" do
        ns = @rule.namespace(@album, @uri, :eager_load => false)
        ns.keys.should == []
      end
    end # context "eager load"

    context "get and update namespace's" do
      before do
        @ns = @rule.namespace(:album, @uri) do |ns|
          ns.composer = @album.composer
        end
      end
      
      it "content" do
        @ns.should be_include(:composer)
    
        @rule.namespace(:album) do |ns|
          ns.delete(:composer)
          ns.title = @album.title
        end
    
        @ns.title.should == @album.title
        @ns.should_not be_include(:composer)
      end
    
      it "uri" do
        new_uri = "http://example.com/albums"
        @ns.uri.should == @uri
        @rule.namespace(:album, new_uri)
        @ns.uri.should == new_uri
      end
    end # context "get and update namespace's"
  end # context "namespace helper"

  def create_link(*args)
    Restfulie::Common::Builder::Rules::Link.new(*args)
  end

  def create_rule(*args, &block)
    Restfulie::Common::Builder::Rules::Base.new(*args, &block)
  end
end