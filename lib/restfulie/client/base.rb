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
  
  # will execute some action in a specific URI
  def self.at(uri)
    Client::RequestExecution.new(nil, nil).at uri
  end
  
  module Client
    
    class << self
      attr_accessor :cache_provider
    end
    
    module Base
      # Extends your class to support restfulie-client side's code.
      # This will extends Restfulie::Client::Base methods as class methods,
      # Restfulie::Client::InstanceMethods as instance methods and Restfulie::Unmarshalling as class methods.
      def uses_restfulie
        extend  Restfulie::Client::ClassMethods
        include Restfulie::Client::InstanceMethods
        extend  Restfulie::Unmarshalling
      end
    end
      
    module InstanceMethods
      # list of possible states to access
      def existing_relations
        @existing_relations ||= {}
      end

      # which content-type generated this data
      attr_reader :_came_from

      # prepares a new request
      def request
        Restfulie::Client::RequestExecution.new(self.class, self)
      end

      # parse arguments from a transition invocation (or relation)
      # it will receive either zero, one or two args, if there are two args, return them
      # if there is one hash arg, its the options, add a data = nil
      # if there is one arg (not a hash), its the data, add a options = {}
      # if there are no args, data is nil and options = {}
      def parse_args_from_transition(*args)
        args = [nil, args[0]] if args.size == 1 && args.first.kind_of?(Hash)
        
        # [data, options]
        [args[0], args[1] || {}]
      end

      def invoke_remote_transition(name, args, block = nil)

        data, options = parse_args_from_transition(*args)

        method = Restfulie::Client::Config.requisition_method_for options[:method], name
        state = self.existing_relations[name]

        request = Restfulie::Client::RequestExecution.new(self.class, self).at(state["href"] || state[:href]).with(options[:headers])
        request.do method, name, data

      end

      # inserts all links from this object as can_xxx and xxx methods
      def add_transitions(links)
        links.each do |t|
          self.existing_relations[t["rel"] || t[:rel]] = t
          self.add_state(t)
        end
        self.extend Restfulie::Client::State
      end

      # adds the specific information for one state change or related resource
      def add_state(transition)
        name = transition["rel"] || transition[:rel]

        # TODO: wrong, should be instance_eval
        self.class.module_eval do

          def temp_method(*args, &block)
            self.invoke_remote_transition(Restfulie::Client::Helper.current_method, args, block)
          end

          alias_method name, :temp_method
          undef :temp_method
        end
      end  

      # returns a list of extended fields for this instance.
      # extended fields are those unknown to this model but kept in a hash
      # to allow forward-compatibility.
      def extended_fields
        @extended_fields ||= {}
        @extended_fields
      end

      def method_missing(name, *args)
        name = name.to_s if name.kind_of? Symbol

        if name[-1,1] == "="
          extended_fields[name.chop] = args[0] 
        elsif name[-1,1] == "?"
          found = extended_fields[name.chop]
          return super(name,args) if found.nil?
          parse(found)
        else
          found = extended_fields[name]
          return super(name) if found.nil?
          parse(transform(found))
        end

      end

      def respond_to?(sym)
        extended_fields[sym.to_s].nil? ? super(sym) : true
      end

      # redefines attribute definition allowing the invocation of method_missing
      # when an attribute does not exist
      def attributes=(values)
        values.each do |key, value|
          unless attributes.include? key
            method_missing("#{key}=", value)
            values.delete key
          end
        end
        super(values)
      end

      # serializes the extended fields with the existing fields
      def to_xml(options={})
        super(options) do |xml|
          extended_fields.each do |key,value|
            xml.tag! key, value
          end
        end
      end

      private

      # transforms a value in a custom hash
      def transform(value)
        return CustomHash.new(value) if value.kind_of?(Hash) || value.kind_of?(Array)
        value
      end

      def parse(val)
        raise "undefined method: '#{val}'" if val.nil?
        val
      end
    end
  
    module ClassMethods
  
      def is_self_retrieval?(name)
        name = name.to_sym if name.kind_of? String
        Restfulie::Client::Config.self_retrieval.include? name
      end
    
      # configures an entry point
      def entry_point_for
        @entry_points ||= EntryPointControl.new(self)
        @entry_points
      end
    
      # executes a POST request to create this kind of resource at the server
      def remote_create(content)
        content = content.to_xml unless content.kind_of? String
        remote_post content
      end
    
      # handles which types of responses should be automatically followed
      def follows
        @follower ||= FollowConfig.new
        @follower
      end
    
      # retrieves a resource form a specific uri
      def from_web(uri, options = {})
        RequestExecution.new(self, nil).at(uri).get(options)
      end

      private
      def remote_post(content)
        RequestExecution.new(self, nil).at(entry_point_for.create.uri).post(content)
      end
  
    end
    
  end
end
