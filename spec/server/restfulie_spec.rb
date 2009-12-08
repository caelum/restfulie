require 'net/http'
require 'uri'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class RestfulieModel < ActiveRecord::Base
  attr_accessor :content
end

class Order < ActiveRecord::Base
  attr_accessor :buyer
end

class MockedController
  def url_for(x)
    "http://url_for/#{x[:action]}"
  end
end

context RestfulieModel do

  before do
    subject.status = :unpaid
  end

  context "when checking the available transitions" do
    it "should return nothing if there is no status field" do
      class Client
        acts_as_restfulie
      end
      c = Client.new
      c.available_transitions.should == {:allow=>[]}
    end
    it "should return nothing if there is status field is nil" do
      class Client
        acts_as_restfulie
        def status
          nil
        end
      end
      c = Client.new
      c.available_transitions.should == {:allow=>[]}
    end
  end
  
  context "when checking permissions" do
    it "should add can_xxx methods allowing one to check whther the transition is valid or not" do
        my_controller = MockedController.new
        RestfulieModel.acts_as_restfulie
        RestfulieModel.transition :pay, {}
        RestfulieModel.state :unpaid, :allow => :pay
        RestfulieModel.state :paid
        
        subject.status = :unpaid
        subject.can_pay?.should eql(true)
  
        subject.status = :paid
        subject.can_pay?.should eql(false)
        
    end
  end
  
  context "when invoking acts_as_restfulie" do
    class CustomAccount
    end
    it "should add all methods from Restfulie::Base to the target class" do
        CustomAccount.acts_as_restfulie
        Restfulie::Server::Base.methods.each do |m|
          CustomAccount.methods.include? m
        end
    end
  end
end
