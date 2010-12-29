require 'spec_helper'

describe Restfulie::Client::StackNavigator do
  
  context "when navigating through the filter list" do
    
    class DoNothing
      def execute(stack, *args)
      end
    end
    
    class InvokeNext
      def execute(stack, *args)
        stack.continue(*args)
      end
    end
    
    it "should invoke the first one" do
      do_nothing = DoNothing.new
      DoNothing.should_receive(:new).and_return(do_nothing)
      parser = Restfulie::Client::StackNavigator.new([:type => DoNothing])
      def parser.dup
        self
      end
      
      args = [:req, :env]

      do_nothing.should_receive(:execute).with(parser, *args)
      parser.continue(*args)
    end

    it "should invoke first the most recent ones" do
      do_nothing = DoNothing.new
      DoNothing.should_receive(:new).and_return(do_nothing)
      parser = Restfulie::Client::StackNavigator.new([:type => InvokeNext, :type => DoNothing])
      def parser.dup
        self
      end
      
      args = [:req, :env]

      do_nothing.should_receive(:execute).with(parser, *args)
      parser.continue(*args)
    end
    
  end
  
  class Client
    def initialize(name)
      @name = name
    end
    attr_reader :name
  end

  class Owner
    def initialize(name = "adriano")
      @name = name
    end
    attr_reader :name
  end

  context "when instantiating filters" do
    it "should pass on the arg" do
      instantiator = Restfulie::Client::BasicInstantiator.new
      client = instantiator.new Client, "guilherme"
      client.name.should == "guilherme"
    end
    it "should be capable of instantiating with no args" do
      instantiator = Restfulie::Client::BasicInstantiator.new
      client = instantiator.new Owner, nil
      client.name.should == "adriano"
    end
  end

end
