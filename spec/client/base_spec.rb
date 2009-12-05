require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class CustomType < ActiveRecord::Base
  uses_restfulie
end

context Restfulie::Client::Base do

  context "while checking for GET verbs that extract info" do

    it "should be self refreshers only in self retrieval" do
      Restfulie::Client::Base::SELF_RETRIEVAL.each do |key|
        CustomType.is_self_retrieval?(key).should eql(true)
      end
    end

    it "should be self refreshers only in self retrieval, but also strings" do
      Restfulie::Client::Base::SELF_RETRIEVAL.each do |key|
        CustomType.is_self_retrieval?(key.to_s).should eql(true)
      end
    end

  end
end