ROOT_PATH = File.dirname(__FILE__)
$:.unshift(ROOT_PATH) unless $:.include?(ROOT_PATH)

require 'restfulie/client'
require 'restfulie/server'

# Shortcut to Restfulie::Client::EntryPoint
module Restfulie
  extend Restfulie::Client::EntryPoint
  
  def self.at(uri)
    Object.new.send(:extend, Restfulie::Client::EntryPoint).at(uri)
  end
end
