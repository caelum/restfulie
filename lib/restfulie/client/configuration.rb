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

  class Configuration

    @@default_configuration = {
      :hosts => ['http://localhost:3000/']
    }

    @@default_configuration.keys.each do |conf_name|
      attr_accessor conf_name
    end

    attr_reader :environment

    def initialize(file='./config/restfulie_client.yml',env=:development)
      if ::File.exist?(file)
        self.read file, env
      else
        @@config = { env => @@default_configuration.dup }
        self.environment = env
      end
    end

    def read(file,env=:development)
      raise "Undefined file" if file.nil?
      raise "File #{file} not found" unless ::File.exist?(file)
      @@config = ::YAML.load_file(file)
      self.environment = env.to_sym
    end

    def environment=(env)
      raise "Undefined env" if env.nil?
      @@env = env
      load_config @environment = env
    end

    def self.[](conf_name)
      @@config[@@env.to_sym][conf_name]
    end

    private
    def load_config(env)
      raise "Undefined configuration" if @@config.nil?
      key = env
      raise "Undefined env=#{key} in config=#{@@config.inspect}" unless @@config.has_key?(key)
    end

  end
  
end
