$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

require 'restfulie/version'
require 'restfulie/common'
require 'restfulie/client'
require 'restfulie/server'

# Shortcut to Restfulie::Client::EntryPoint
module Restfulie

  class RestfulieDsl

    def initialize
      @traits = []
      base
    end

    def method_missing(sym, *args)
      trait = "Restfulie::Client::Feature::#{sym.to_s.classify}".constantize
      @traits << trait
      self.extend trait
      self
    end

  end
  
  # creates a new entry point for executing requests
  def self.at(uri)
    Restfulie.using {
      recipe
      follow_link
      request_marshaller
      verb_request
    }.at(uri)
  end

  def self.using(&block)
    RestfulieUsing.new.instance_eval(&block)
  end
  
  def self.use(&block)
    RestfulieDsl.new.instance_eval(&block)
  end
  
end

class RestfulieUsing
  def method_missing(sym, *args)
    @current = "Restfulie::Client::HTTP::#{sym.to_s.classify}".constantize.new(@current || Restfulie::Client::HTTP::RequestAdapter.new, *args)
  end
end
