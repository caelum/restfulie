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

module Restfulie::Serializer
  @@serializers_path = [File.join(File.dirname(__FILE__), 'serializers')]
  mattr_accessor :serializers_path

  class << self
    # Remove to_json from ActiveSupport in the class
    # I want my own to_json
    undef_method :to_json if respond_to?(:to_json)
    
    def respond_to?(symbol, include_private = false)
      unless (serializer_name = parse_name(symbol)).nil?
        serializers.include?(serializer_name)
      else
        super
      end
    end

    def method_missing(symbol, *args)
      serializer_name = parse_name(symbol)
      if !serializer_name.nil? && serializers.include?(serializer_name)
        initialize_serializer(serializer_name)
      else
        super
      end
    end
    
    def serializers
      @serializers = [] unless defined? @serializers
      load_serializers
    end
    
  private

    def parse_name(method)
      if serializer_name = method.to_s.match(/to_(.*)/)
        serializer_name[1]
      end
    end
  
    def load_serializers
      self.serializers_path.reject! do |path|
        Dir["#{path}/*.rb"].each do |file|
          serializer_name = File.basename(file, ".rb").downcase
          @serializers << serializer_name unless @serializers.include?(serializer_name)
          self.autoload(serializer_name.capitalize.to_sym, file) if self.autoload?(serializer_name.capitalize.to_sym).nil?
        end
      end

      @serializers
    end

    def initialize_serializer(serializer_name, *args)
      begin
        "#{self.ancestors.first}::#{serializer_name.capitalize}".constantize.new(*args)
      rescue NameError
        raise Restfulie::Error::UndefinedSerializerError.new("Serializer #{serializer_name.capitalize} not fould.")
      end
    end

  end
end