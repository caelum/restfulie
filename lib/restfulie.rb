$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

require 'restfulie/version'
require 'restfulie/client'
require 'restfulie/server'

# Shortcut to Restfulie::Client::EntryPoint
module Restfulie
  extend Restfulie::Client::EntryPoint
  
  def self.at(uri)
    Object.new.send(:extend, Restfulie::Client::EntryPoint).at(uri)
  end
end
