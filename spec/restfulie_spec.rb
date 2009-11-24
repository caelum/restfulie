require 'net/http'
require 'uri'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class RestfulieModel < ActiveRecord::Base
  attr_accessor :content
  acts_as_restfulie
end

class Order < ActiveRecord::Base
  attr_accessor :buyer
  acts_as_restfulie
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
  
  context "when parsed to json" do
    it "should include the method following_states" do
      subject.to_json.should eql("{\"status\":\"unpaid\"}")
    end
  end
  
  def base
    '<?xml version="1.0" encoding="UTF-8"?><restfulie-model>'
  end
  def link(href, rel)
    '<atom:link xmlns:atom="http://www.w3.org/2005/Atom"' \
     + ' href="' + href + '"'\
     + ' rel="' + rel + '"'\
     + '/>'
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
  
  context "when parsed to xml" do
    
      it "should not add hypermedia if controller is nil" do
        subject.to_xml.gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>unpaid</status></restfulie-model>')
      end
      
      it "should add allowable actions to models xml if controller is set" do
        my_controller = MockedController.new
        RestfulieModel.transition :latest, {:controller => my_controller, :action => :show}
        RestfulieModel.state :unpaid, :allow => :latest
        
        expected = normalize_xml('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>unpaid</status>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" href="http://url_for/show" rel="latest"/></restfulie-model>')
        got      = normalize_xml(subject.to_xml(:controller => my_controller).gsub("\n", ''))
        
        got.should eql(expected)
      end
      
      it "should add more than 1 allowable actions to models xml if controller is set" do
        my_controller = MockedController.new
        RestfulieModel.transition :latest, {:controller => my_controller, :action => :show}
        RestfulieModel.state :unpaid, :allow => [:latest, :latest]
        
        expected = normalize_xml(base + '  <status>unpaid</status>  '+link('http://url_for/show','latest')+'  '+link('http://url_for/show','latest')+'</restfulie-model>')
        got      = normalize_xml(subject.to_xml(:controller => my_controller).gsub("\n", ''))
        
        got.should eql(expected)
      end
      
      it "should add extra transitions if following_transitions are defined" do
        my_controller = MockedController.new
        RestfulieModel.transition :latest, {:controller => my_controller, :action => :show}
        RestfulieModel.state :unpaid, :allow => [:latest]
        def subject.following_transitions
          [:latest]
        end
        
        expected = normalize_xml(base + '  <status>unpaid</status>  '+link('http://url_for/show','latest')+'  '+link('http://url_for/show','latest')+'</restfulie-model>')
        got      = normalize_xml(subject.to_xml(:controller => my_controller).gsub("\n", ''))
        
        got.should eql(expected)
      end
      
      it "should add and create extra transition through following_transitions" do
        my_controller = MockedController.new
        RestfulieModel.state :unpaid, :allow => []
        def subject.following_transitions
          [[:latest, { :action => :thanks }]]
        end
        
        expected = normalize_xml(base + '  <status>unpaid</status>  '+link('http://url_for/thanks','latest')+'</restfulie-model>')
        got      = normalize_xml(subject.to_xml(:controller => my_controller).gsub("\n", ''))
        
        got.should eql(expected)
      end
      
      it "should add hypermedia link if controller is set and told to use name based link" do
        my_controller = MockedController.new
        RestfulieModel.transition :latest, {:controller => my_controller, :action => :show}
        RestfulieModel.state :unpaid, :allow => [:latest]
        subject.to_xml(:controller => my_controller, :use_name_based_link => true).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>unpaid</status>  <latest>http://url_for/show</latest></restfulie-model>')
      end
      
      it "should use rel if there is a rel attribute" do
         my_controller = MockedController.new
         RestfulieModel.transition :latest, {:controller => my_controller, :action => :show, :rel => :show_me_the_latest}
         RestfulieModel.state :unpaid, :allow => [:latest]
         subject.to_xml(:controller => my_controller, :use_name_based_link => true).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>unpaid</status>  <show_me_the_latest>http://url_for/show</show_me_the_latest></restfulie-model>')
      end
      
      it "should evaluate in runtime if there is a block to define the transition" do
        my_controller = MockedController.new
        RestfulieModel.transition :latest do |me|
           {:action => me.content}
        end
        RestfulieModel.state :unpaid, :allow => [:latest]
        subject.content = :show
        subject.to_xml(:controller => my_controller, :use_name_based_link => true).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>unpaid</status>  <latest>http://url_for/show</latest></restfulie-model>')
      end
      
      it "should use transition name if there is no action" do
        my_controller = MockedController.new
        RestfulieModel.transition :pay
        RestfulieModel.state :unpaid, :allow => [:pay]
        
        expected = normalize_xml('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>unpaid</status>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" href="http://url_for/pay" rel="pay"/></restfulie-model>')
        got      = normalize_xml(subject.to_xml(:controller => my_controller).gsub("\n", ''))
        
        got.should eql(expected)
      end
      
      it "should not add anything if in an unknown state" do
        my_controller = MockedController.new
        subject.status = :gone
        subject.to_xml(:controller => my_controller).gsub("\n", '').should eql('<?xml version="1.0" encoding="UTF-8"?><restfulie-model>  <status>gone</status></restfulie-model>')
      end
      
      it "should not change status if there is no result" do
        my_controller = MockedController.new
        RestfulieModel.transition :pay
        RestfulieModel.state :unpaid, :allow => [:pay]
        subject.pay
        subject.status.should eql(:unpaid)
      end
      
      it "should use change status to its result when transitioning" do
        my_controller = MockedController.new
        RestfulieModel.transition :pay, {}, :paid
        RestfulieModel.state :unpaid, :allow => [:pay]
        subject.pay
        subject.status.should eql("paid")
      end
    end
  
  context "when checking permissions" do
      it "should add can_xxx methods allowing one to check whther the transition is valid or not" do
          my_controller = MockedController.new
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
