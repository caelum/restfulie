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
#
module Restfulie::Client

  class Initializer

    attr_accessor :configuration

    def self.run(command = :process, configuration = Restfulie::Client::Configuration.new)
      yield configuration if block_given?
      initializer = new configuration
      initializer.send(command)
      initializer
    end

    def initialize(configuration)
      @configuration = configuration
    end

    def process
      load_entry_points
    end

    def load_entry_points
      @configuration.entry_points.each do |const_name,entry_point|
        Object.const_set( const_name.to_s.camelize, Restfulie::Client::EntryPoint.at(entry_point) )
      end
    end

  end

end

