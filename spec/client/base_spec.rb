require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class CustomType < ActiveRecord::Base
  uses_restfulie
end
class Item
end

context Restfulie::Client::Config do

  context "while checking for GET verbs that extract info" do

    it "should be self refreshers only in self retrieval" do
      Restfulie::Client::Config.self_retrieval.each do |key|
        CustomType.is_self_retrieval?(key).should be_true
      end
    end

    it "should be self refreshers only in self retrieval, but also strings" do
      Restfulie::Client::Config.self_retrieval.each do |key|
        CustomType.is_self_retrieval?(key.to_s).should be_true
      end
    end

  end
  
  context "when deciding which http method to use" do
    
    it "should use overriden values if available" do
      [:delete, :put, :get, :post].each do |option|
        Restfulie::Client::Config.requisition_method_for(option, nil).should eql("Net::HTTP::#{option.to_s.camelcase}".constantize)
      end
    end

    it "should use default delete values" do
      [:destroy, :delete, :cancel].each do |option|
        Restfulie::Client::Config.requisition_method_for(nil, option).should eql(Net::HTTP::Delete)
      end
    end

    it "should use overriden values if available" do
      [:refresh, :reload, :show, :latest, :self].each do |option|
        Restfulie::Client::Config.requisition_method_for(nil, option).should eql(Net::HTTP::Get)
      end
    end
  end
  
end
