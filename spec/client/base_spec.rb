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
end
