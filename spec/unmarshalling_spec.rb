require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Restfulie
  module Unmarshalling
    class Product
    end
    class Player
      uses_restfulie
      acts_as_jeokkarak
      attr_accessor :link
    end
    class Person < ActiveRecord::Base
      uses_restfulie
      attr_accessor :link
    end
  end
end

describe Restfulie do
  
  context "when creating an object from a hash" do
    it "should extract no links if there are none" do
      hash = {}
      product = Hashi.to_object hash
      product.nil?.should be_false
    end
    it "should extract a link" do
      hash = {"link" => {:rel => "latest", :href => "http://www.caelumobjects.com/product/2"}}
      product = Hashi.to_object hash
      product.respond_to?(:latest).should be_true
    end
    it "should extract all links" do
      hash = {"link" => [{:rel => "latest", :href => "http://www.caelumobjects.com/product/2"},
                         {:rel => "destroy", :href => "http://www.caelumobjects.com/product/2"}]}
      product = Hashi.to_object hash
      product.respond_to?(:latest).should be_true
      product.respond_to?(:destroy).should be_true
    end
  end
  
  context "when creating a Jeokkarak from a hash" do
    it "should extract no links if there are none" do
      hash = {}
      player = Restfulie::Unmarshalling::Player.from_hash hash
      player.nil?.should be_false
    end
    it "should extract a link" do
      hash = {"link" => {:rel => "latest", :href => "http://www.caelumobjects.com/product/2"}}
      player = Restfulie::Unmarshalling::Player.from_hash hash
      player.respond_to?(:latest).should be_true
    end
    # it "should extract all links" do
    #   hash = {"link" => [{:rel => "latest", :href => "http://www.caelumobjects.com/product/2"},
    #                      {:rel => "destroy", :href => "http://www.caelumobjects.com/product/2"}]}
    #   player = Restfulie::Unmarshalling::Player.from_hash hash
    #   player.respond_to?(:latest).should be_true
    #   player.respond_to?(:destroy).should be_true
    # end
  end

  context "when creating a JeokkarakActiveRecord from a hash" do
    it "should extract no links if there are none" do
      hash = {}
      player = Restfulie::Unmarshalling::Person.from_hash hash
      player.nil?.should be_false
    end
    # it "should extract a link" do
    #   hash = {"link" => {:rel => "latest", :href => "http://www.caelumobjects.com/product/2"}}
    #   player = Restfulie::Unmarshalling::Person.from_hash hash
    #   player.respond_to?(:latest).should be_true
    # end
    # it "should extract all links" do
    #   hash = {"link" => [{:rel => "latest", :href => "http://www.caelumobjects.com/product/2"},
    #                      {:rel => "destroy", :href => "http://www.caelumobjects.com/product/2"}]}
    #   player = Restfulie::Unmarshalling::Person.from_hash hash
    #   player.respond_to?(:latest).should be_true
    #   player.respond_to?(:destroy).should be_true
    # end
  end
  
end