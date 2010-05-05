require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Proc do
  it "should attribute helpers accessor" do
    block = lambda {}
    block.helpers = ProcSpec::DowncaseHelper
    block.helpers.should eql(ProcSpec::DowncaseHelper)
  end
  
  it "should allow an extension module" do
    @title = "Proc Extended Spec"
    block = lambda do
      title(@title)
    end

    block.helpers = ProcSpec::DowncaseHelper
    block.call.should eql(@title.downcase)
  end
  
  it "should allow multi extension module" do
    @title = "Proc Extended Spec"
    @url   = "example.com"
    block = lambda do
      [title(@title), add_http(@url)]
    end

    block.helpers = [ProcSpec::DowncaseHelper, ProcSpec::HttpHelper]
    block.call.should eql([@title.downcase, "http://#{@url}"])
  end

  it "should allow nested blocks" do
    @title = "Proc Extended Spec"
    @url   = "example.com"
    block = lambda do
      inter_block = lambda do
        title(@title)
      end
      inter_block.call_include_helpers(ProcSpec::DowncaseHelper)
      [title(@title), add_http(@url)]
    end
    block.helpers = [ProcSpec::DowncaseHelper, ProcSpec::HttpHelper]
    block.call.should eql([@title.downcase, "http://#{@url}"])
  end
  
  it "should not change context class" do
    f = ProcSpec::Foo.new
    f.exec_block { |a| a.links << link("self", "http://example.com/albums/1") }
    f.should_not respond_to(:link)
  end
  
  it "should pass parameters for block" do
    f = ProcSpec::Foo.new
    f.exec_block { |a| a }.should be_kind_of(ProcSpec::Bar)
  end
  
  it "should not replace original method missing" do
    f = ProcSpec::Foo.new
    f.exec_block { |a| a }
    f.booo.should eql("method booo not implemented")
  end

  it "should pass block to helper method" do
    result = nil
    f = Proc.new do
      exec_block do
        result = "Internal block executed"
      end
    end

    f.helpers = ProcSpec::BlockPass
    f.call
    result.should == "Internal block executed"
  end

  it "should raise error" do
    f = Proc.new {}
    f.call_include_helpers(ProcSpec::BlockPass)
    lambda {
      foo_method(nil)
    }.should raise_error(NameError)
  end

  it "should raise error for argument" do
    f = Proc.new { title("title", "not valid argument") }
    lambda {
      f.call_include_helpers(ProcSpec::DowncaseHelper)
    }.should raise_error(ArgumentError)
  end
  
end # context Proc

module ProcSpec
  module DowncaseHelper
    def title(value)
      value.downcase
    end
  end

  module HttpHelper
    def add_http(value)
      "http://#{value}"
    end
  end

  module BlockPass
    def exec_block(&block)
      block.call
    end
  end

  class Bar
    attr_accessor :links
    
    def initialize
      @links = []
    end
  end

  class Foo
    def exec_block(&block)
      block.call_include_helpers(FooHelpers, Bar.new)
    end
  
    def method_missing(symbol, *args)
      "method #{symbol} not implemented"
    end
  
    module FooHelpers
      def link(rel, href)
        [rel, href]
      end
    end
  end
end

