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

