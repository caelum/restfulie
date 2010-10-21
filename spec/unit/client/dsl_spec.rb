require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Restfulie::Client::Dsl do
  
  context "when navigating through the filter list" do
    
    class Factory
      def initialize(what)
        @what = what
      end
      def new
        @what
      end
    end
    
    it "should invoke the first one" do
      do_nothing = Object.new
      factory = Factory.new(do_nothing)
      parser = Restfulie::Client::Parser.new([factory])
      
      args = [1, 2, 3]

      do_nothing.should_receive(:execute).with(parser, args)
      parser.continue(args)
    end
    
  end

end
