require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie do

  context "when building restfulie" do
  
    it "should create a restfulie with an at method" do
      Restfulie.respond_to?(:at).should be_true
    end
    
    module Restfulie::Client::Feature::Custom
      def custom_history
      end
    end
    class Restfulie::Client::Feature::CustomRequest
      def custom_history
      end
    end
    
    it "should allow adding extra methods by usage" do
      Restfulie.use{custom}.respond_to?(:custom_history).should be_true
    end
    
    it "should accepts the old methods after adding new ones" do
      Restfulie.use{custom}.respond_to?(:at).should be_true
    end
    
  end

end
