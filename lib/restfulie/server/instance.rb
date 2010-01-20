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

module Restfulie::Server::Cache
  
  # returns specific cache information for this resource
  # you may customize it and return a custom etag and last_modified fields
  def cache_info
    info = {:etag => self}
    info[:etag] = self.etag if self.respond_to? :etag
    info[:last_modified] = self.updated_at.utc if self.respond_to? :updated_at
    info
  end
  
end

# acts_as_restfulie instances implement this module
module Restfulie::Server::Instance

  include Restfulie::Server::Cache
  
  # checks whether this resource can execute a transition or has such a relation
  def can?(what)
    what = what.to_sym if what.kind_of? String
    all_following_transitions.each do |t|
      return true if t.name == what
    end
    false
  end

  # returns a list of available transitions for this objects state
  # TODO rename because it should never be used by the client...
  def available_transitions
    status_available = respond_to?(:status) && status!=nil
    return {:allow => []} unless status_available
    self.class.states[self.status.to_sym] || {:allow => []}
  end
  
  # returns a list containing all available transitions for this object's state
  def all_following_transitions
    all = [] + available_transitions[:allow]
    following_transitions.each do |t|
      t = Restfulie::Server::Transition.new(t) if t.kind_of? Array
      all << t
    end
    all
  end

  # checks if its possible to execute such transition and, if it is, executes it
  def move_to(name)
    raise "Current state #{status} is invalid in order to execute #{name}. It must be one of #{transitions}" unless available_transitions[:allow].include? name
    self.class.transitions[name].execute_at self
  end
  
  # gets all the links for each transition
  def links(controller)
    links = []
    unless controller.nil?
      all_following_transitions.each do |transition|
        rel, uri = link_for(transition, controller)
        links << {:rel => rel, :uri => uri}
      end
    end
    links
  end

  private
  # gets a link for this transition
  def link_for(transition, controller) 
    transition = self.class.existing_transition(transition.to_sym) unless transition.kind_of? Restfulie::Server::Transition
    transition.link_for(self, controller)
  end

end

class Array
  
  include Restfulie::Server::Cache

  def updated_at
    last = nil
    each do |item|
      last = item.updated_at if item.respond_to?(:updated_at) && (last.nil? || item.updated_at > last)
    end
    last || Time.now
  end
  
end
