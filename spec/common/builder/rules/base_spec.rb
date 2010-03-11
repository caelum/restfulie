require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

context Restfulie::Builder::Rules::Base do
  it "should respond to links and links is a collection" do
    @rule = create_rule
    @rule.should respond_to(:links)
    (@rule.links << create_link(:self)).should_not be_nil
  end
  
  it "should respond to blocks and links is a collection" do
    block_one = lambda {}
    @rule = create_rule(&block_one)
    
    @rule.should respond_to(:blocks)
    @rule.blocks.should be_include(block_one)
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

  context "namespace helper" do
    before do
      @rule  = create_rule()
      @album = { :cp => "Designer Drugs", :title => "Album title" }
      @uri   = "http://albums.example.com"
    end

    it "should create a new namespace" do
      ns = @rule.namespace(:album, @uri) do |ns|
        ns.composer = @album[:cp]
      end
      ns.composer.should == @album[:cp]
    end

    context "get and update namespace's" do
      before do
        @ns = @rule.namespace(:album) do |ns|
          ns.composer = @album[:cp]
        end
      end
      
      it "content" do
        @ns.should be_include(:composer)

        @rule.namespace(:album) do |ns|
          ns.delete(:composer)
          ns.title = @album[:title]
        end

        @ns.title.should == @album[:title]
        @ns.should_not be_include(:composer)
      end

      it "uri" do
        @ns.uri.should be_nil
        @rule.namespace(:album, @uri)
        @ns.uri.should == @uri
      end
    end # context "get and update namespace's"
  end # context "namespace helper"

  def create_link(*args)
    Restfulie::Builder::Rules::Link.new(*args)
  end

  def create_rule(&block)
    Restfulie::Builder::Rules::Base.new(&block)
  end
end