#
#  Copyright (c) 2009 Caelum - www.caelum.com.br/opensource
#  All rights reserved.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); 
#  you may not use this file except in compliance with the License. 
#  You may obtain a copy of the License at 
#  
#   http://www.apache.org/licenses/LICENSE-2.0 
#  
#  Unless required by applicable law or agreed to in writing, software 
#  distributed under the License is distributed on an "AS IS" BASIS, 
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
#  See the License for the specific language governing permissions and 
#  limitations under the License. 
#

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Product
end
class Player < ActiveRecord::Base
  uses_restfulie
  belongs_to :team
  attr_accessor :link, :name
end
class Team < ActiveRecord::Base
  uses_restfulie
  has_many :players
  accepts_nested_attributes_for :players
end
class Person < ActiveRecord::Base
  uses_restfulie
  attr_accessor :link
end

describe Restfulie do
  
  context "when creating an object from a hash" do
    it "should extract no links if there are none" do
      hash = {}
      product = Hashi.to_object hash
      product.should_not be_nil
    end
    it "should extract a link" do
      hash = {"link" => {:rel => "latest", :href => "http://www.caelumobjects.com/product/2"}}
      product = Hashi.to_object hash
      product.should respond_to(:latest)
    end
    it "should extract all links" do
      hash = {"link" => [{:rel => "latest", :href => "http://www.caelumobjects.com/product/2"},
                         {:rel => "destroy", :href => "http://www.caelumobjects.com/product/2"}]}
      product = Hashi.to_object hash
      product.should respond_to(:latest)
      product.should respond_to(:destroy)
    end
  end
  
  context "when creating an object from a hash" do
    it "should create that class's object" do
      hash = {"name" => "guilherme silveira"}
      player = Player.from_hash(hash)
      player.class.should == Player
    end
    it "should allow direct attribute access" do
      hash = {"name" => "guilherme silveira"}
      player = Player.from_hash(hash)
      player.name.should == "guilherme silveira"
    end
    it "should allow direct attribute attribution" do
      hash = {"name" => "guilherme silveira"}
      player = Player.from_hash(hash)
      player.name = "donizetti"
      player.name.should == "donizetti"
    end
    it "should allow direct new attribute access" do
      hash = {"age" => 29}
      player = Player.from_hash(hash)
      player.age.should == 29
    end
    it "should allow direct new attribute attribution" do
      hash = {"age" => 28}
      player = Player.from_hash(hash)
      player.age = 29
      player.age.should == 29
    end
    
    it "should allow access to child element when hash came from rails from_xml" do
      hash = {"players" => {"player" => {"name" => "guilherme silveira"}}}
      team = Team.from_hash(hash)
      team.players[0].class.should == Player
      team.players[0].name.should == "guilherme silveira"
    end
    it "should allow access to children when hash came from rails from_xml" do
      hash = {"players" => {"player" => [{"name" => "guilherme silveira"},{"name" => "andre de santi"}]}}
      team = Team.from_hash(hash)
      team.players[0].class.should == Player
      team.players[0].name.should == "guilherme silveira"
      team.players[1].class.should == Player
      team.players[1].name.should == "andre de santi"
    end
  
    it "should allow access to child element" do
      hash = {"players" => [{"name" => "guilherme silveira"}]}
      team = Team.from_hash(hash)
      team.players[0].class.should == Player
      team.players[0].name.should == "guilherme silveira"
    end
    it "should allow access to boolean element" do
      hash = {"players" => [{"name" => "guilherme silveira", "valid" => true}]}
      team = Team.from_hash(hash)
      team.players[0].should be_valid
    end
    it "should allow access attribution to child element" do
      hash = {"players" => [{"name" => "guilherme silveira"}]}
      team = Team.from_hash(hash)
      team.players[0].name = "donizetti"
      team.players[0].name.should == "donizetti"
    end
    it "should allow access to an array element" do
      hash = {"players" => [{"name" => "guilherme silveira"}, {"name" => "caue guerra"}]}
      team = Team.from_hash(hash)
      team.players[0].class.should == Player
      team.players[1].class.should == Player
      team.players[1].name.should == "caue guerra"
    end
    it "should allow access attribution to an array element" do
      hash = {"players" => [{"name" => "guilherme silveira"}, {"name" => "caue guerra"}]}
      team = Team.from_hash(hash)
      team.players[1].name = "donizetti"
      team.players[1].name.should == "donizetti"
    end
        
  end
  context "when creating a Jeokkarak from a hash" do
    it "should extract no links if there are none" do
      hash = {}
      player = Player.from_hash hash
      player.should_not be_nil
    end
    it "should extract a link" do
      hash = {"link" => {:rel => "latest", :href => "http://www.caelumobjects.com/product/2"}}
      player = Player.from_hash hash
      player.should respond_to(:latest)
    end
    it "should extract all links" do
      hash = {"link" => [{:rel => "latest", :href => "http://www.caelumobjects.com/product/2"},
                         {:rel => "destroy", :href => "http://www.caelumobjects.com/product/2"}]}
      player = Player.from_hash hash
      player.should respond_to(:latest)
      player.should respond_to(:destroy)
    end
  end
  
  context "when creating an array of elements from a hash which was created from rails from_xml" do

    it "should create that class's object" do
      hash = {"player" => {"name" => "guilherme silveira"}}
      player = Player.array_from_hash(hash)
      player[0].name.should == "guilherme silveira"
    end

    it "should create that class's object" do
      hash = {"player" => [{"name" => "guilherme silveira"}, {"name" => "andre de santi"}]}
      player = Player.array_from_hash(hash)
      player[0].name.should == "guilherme silveira"
      player[1].name.should == "andre de santi"
    end

  end
  
  context "when creating a JeokkarakActiveRecord from a hash" do
    it "should extract no links if there are none" do
      hash = {}
      player = Person.from_hash hash
      player.should_not be_nil
    end
    it "should extract a link" do
      hash = {"link" => {:rel => "latest", :href => "http://www.caelumobjects.com/product/2"}}
      player = Person.from_hash hash
      player.should respond_to(:latest)
    end
    it "should extract all links" do
      hash = {"link" => [{:rel => "latest", :href => "http://www.caelumobjects.com/product/2"},
                         {:rel => "destroy", :href => "http://www.caelumobjects.com/product/2"}]}
      player = Person.from_hash hash
      player.should respond_to(:latest)
      player.should respond_to(:destroy)
    end
  end
  
  context "when unmarshalling with relations" do
    
    class Unit
      uses_restfulie
      attr_accessor :name
      attr_accessor :children
    end
    
    class Truck
      uses_restfulie
      attr_accessor :brand
    end
    
    it "should work with default data" do
      Unit.from_hash({:name => "guilherme"}).name.should == "guilherme"
    end
    
    it "should work with a collection of child elements" do
      Unit.from_hash({:children => [{:brand => "fiat"}]}).children[0].brand.should == "fiat"
    end
    
    it "should work with a ActiveRecord relationship" do
      def Unit.reflect_on_association(key)
        o = Object.new
        def o.klass
          :Truck
        end
        o
      end
      child = Unit.from_hash({:children => [{:brand => "fiat"}]}).children[0]
      child.should be_kind_of(Truck)
      child.brand.should == "fiat"
    end
    
    it "should support Jeokkarak with a child which does not have from_hash" do
      class Car
        uses_restfulie
      end
      def Unit.reflect_on_association(key)
        o = Object.new
        def o.klass
          :Car
        end
        o
      end
      child = Unit.from_hash({:children => [{:brand => "fiat"}]}).children[0]
      child.should be_kind_of(Car)
      child.brand.should == "fiat"
    end
     
  end

end