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

  class Configuration < ::Hash

    attr_reader :entry_point_host 
    attr_reader :entry_point_path 
    attr_reader :environment

    @@default_configuration = {
      :entry_point     => '',
      :default_headers => { 
        :get  => { 'Accept'       => 'application/atom+xml' },
        :post => { 'Content-Type' => 'application/atom+xml' } 
      },
      :auto_follows => {} #:auto_follows => { 301 => [:post,:put,:delete] }
    }

    def initialize
      super
      @environment = :development
      store(@environment , @@default_configuration.dup)
    end

    def environment=(value)
      @environment = value
      unless has_key?(@environment) 
        store(@environment,@@default_configuration.dup)
      end
      @environment
    end

    #def initialize(file,env=:development)
      #raise "Undefined file" unless file
      #raise "File #{file} not found" unless ::File.exist?(file)
      #merge!( ::YAML.load_file(file).sympolyse_keys! )
    #end

    def [](key)
      fetch(environment)[key]
    end

    def []=(key,value)
      fetch(environment)[key] = value
    end 

    def entry_point_path
      parse_entry_point
      @entry_point_path
    end

    def entry_point_host
      parse_entry_point
      @entry_point_host
    end

    def method_missing(name, *args, &block)
      method_name = name.to_s
      if method_name.last == '='
        fetch(environment)[method_name.chop.to_sym] = args[0]
      else
        value = fetch(environment)[name]
        super unless value
        value
      end
    end

    private 

    def parse_entry_point
      return @entry_point_host = @entry_point_path = nil if entry_point.empty?
      uri = ::URI.parse(entry_point)
      @entry_point_host = "#{uri.scheme}://#{uri.host}:#{uri.port}"
      @entry_point_path = uri.path
    end

  end
  
end
