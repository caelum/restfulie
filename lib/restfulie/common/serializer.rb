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
  SERIALIZERS_PATH = File.join(File.dirname(__FILE__), 'serializers')
  
  class << self
    def method_missing(name, *args)
      if serializer_class_name = name.to_s.match(/to_(.*)/)
        initialize_serialize(serializer_class_name[1], *args)
      else
        super
      end
    end

    # TODO: Improve the autoload of serializers
    def initialize_serialize(name, *args)
      unless self.const_defined?(name.capitalize.to_sym)
        begin
          require "#{SERIALIZERS_PATH}/#{name}"
        rescue MissingSourceFile
          raise Restfulie::Error::UndefinedSerializerError.new("Serializer #{name.capitalize} not fould.")
        end
      end

      "#{self.ancestors.first}::#{name.capitalize}".constantize.new(*args)
    end
  end
end