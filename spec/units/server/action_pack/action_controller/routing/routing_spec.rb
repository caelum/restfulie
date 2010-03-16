require File.join(File.dirname(__FILE__),'..','..','..','..','spec_helper')

module Restfulie::Server::ActionController::Test
  class AlbumsController < Restfulie::Server::ActionController::Base
    def index
    end
  end
end

ActionController::Routing::Routes.draw do |map|
end

describe Restfulie::Server::ActionController::Base, :type => :controller do
  tests AlbumsController
  
  before(:each) do
  end
  
end

