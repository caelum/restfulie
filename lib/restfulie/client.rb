require 'net/http'
require 'uri'
require 'vendor/jeokkarak/jeokkarak'

require 'restfulie/media_type'
require 'restfulie/client/atom_media_type'
require 'restfulie/client/base'
require 'restfulie/client/entry_point'
require 'restfulie/client/helper'
require 'restfulie/client/instance'
require 'restfulie/client/request_execution'
require 'restfulie/client/state'
require 'restfulie/unmarshalling'

module Restfulie
  
  # Extends your class to support restfulie-client side's code.
  # This will extends Restfulie::Client::Base methods as class methods,
  # Restfulie::Client::Instance as instance methods and Restfulie::Unmarshalling as class methods.
  def uses_restfulie
    extend Restfulie::Client::Base
    include Restfulie::Client::Instance
    extend Restfulie::Unmarshalling
  end
  
end

Object.extend Restfulie

class Hashi::CustomHash
    uses_restfulie
end
