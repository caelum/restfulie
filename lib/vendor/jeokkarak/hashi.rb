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

module Hashi
  class UndefinedMethod < Exception
    attr_reader :msg
    def initialize(msg)
      @msg = msg
    end
    def to_s
      @msg
    end
  end
  
  class CustomHash
    
    attr_reader :hash

    def initialize(h = {})
      @hash = h
    end
    
    def method_missing(name, *args, &block)
      name = name.to_s if name.kind_of? Symbol
      if name[-1,1] == "?"
        parse(name, @hash[name.chop])
      elsif name[-1,1] == "="
        @hash[name.chop] = args[0]
      elsif @hash.kind_of?(Array) && name == "each"
        @hash.each do |k| block.call(transform(k)) end
      elsif name.respond_to? name
        @hash.send(name, *args, &block)
      else
        return nil if @hash.has_key?(name) && @hash[name].nil?
        parse(name, transform(@hash[name]))
      end
    end
    
    def respond_to?(symbol)
      super(symbol) || (is_hash? && @hash.key?(symbol.to_s))
    end
    
    def is_hash?
      @hash.kind_of? Hash
    end
    
    def [](x)
      transform(@hash[x])
    end
    
    private
    def transform(value)
      return CustomHash.new(value) if value.kind_of?(Hash) || value.kind_of?(Array)
      value
    end
    
    def parse(name, val)
      raise Hashi::UndefinedMethod.new("undefined method '#{name}'") if val.nil?
      val
    end
    
  end
  
  def self.from_hash(h)
    CustomHash.new(h)
  end
  
  def self.to_object(h)
    CustomHash.new(h)
  end
  
end