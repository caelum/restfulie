require 'net/http'
require 'uri'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class AccountController < ActionController::Base
end

describe RestfulieController do
  
  before do
    @subject = AccountController.new
  end
  
  context "when rendering a resource" do
    it "should xmlize the resource" do
      xml = '<resulting_xml></resulting_xml>'
      account = Object.new
      account.should_receive(:to_xml).with({:controller => subject}).and_return(xml)
      subject.should_receive(:simple_render).with(:xml => xml)
      subject.send(:render, :resource => account)
    end
  end
  
end