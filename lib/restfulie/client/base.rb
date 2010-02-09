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

module Restfulie

  class << self
    attr_accessor :cache_provider
  end
  
  # Extends your class to support restfulie-client side's code.
  # This will extends Restfulie::Client::Base methods as class methods,
  # Restfulie::Client::Instance as instance methods and Restfulie::Unmarshalling as class methods.
  def uses_restfulie
    extend Restfulie::Client::Base
    include Restfulie::Client::Instance
    extend Restfulie::Unmarshalling
  end

  # will execute some action in a specific URI
  def self.at(uri)
    Client::RequestExecution.new(nil, nil).at uri
  end
  
  module Client
    module Config
      BASIC_MAPPING = { :delete => Net::HTTP::Delete, :put => Net::HTTP::Put, :get => Net::HTTP::Get, :post => Net::HTTP::Post}
      DEFAULTS = { :destroy => Net::HTTP::Delete, :delete => Net::HTTP::Delete, :cancel => Net::HTTP::Delete,
                   :refresh => Net::HTTP::Get, :reload => Net::HTTP::Get, :show => Net::HTTP::Get, :latest => Net::HTTP::Get, :self => Net::HTTP::Get}

      def self.self_retrieval
        [:latest, :refresh, :reload, :self]
      end
  
      def self.requisition_method_for(overriden_option,name)
        return BASIC_MAPPING[overriden_option.to_sym] if overriden_option
        DEFAULTS[name.to_sym] || Net::HTTP::Post
      end
    
    end
    
    module Base

      def is_self_retrieval?(name)
        name = name.to_sym if name.kind_of? String
        Restfulie::Client::Config.self_retrieval.include? name
      end
    
    end
    
  end
end
