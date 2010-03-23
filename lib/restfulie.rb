module Restfulie
  ROOT_PATH = File.dirname(__FILE__)
  $LOAD_PATH.unshift(ROOT_PATH) unless $LOAD_PATH.include?(ROOT_PATH)
  
end

require 'restfulie/client'
require 'restfulie/server'

