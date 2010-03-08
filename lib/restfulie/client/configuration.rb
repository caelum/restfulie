module Restfulie::Client #:nodoc:

  # Use this class to configure the entry point and other relevant behaviors related to accessing or interacting with resources
  # 
  # The available options are:
  # 
  # * <tt>:entry_point</tt> - The URI for an entry point, such as http://resource.entrypoint.com/post
  # * <tt>:default_headers</tt> - A Hash containing methods as keys and hashes with headers as values. For example:
  # 
  #     :default_headers => { 
  #       :get  => { 'Accept'       => 'application/atom+xml' },
  #       :post => { 'Content-Type' => 'application/atom+xml' } 
  #     }
  # 
  # * <tt>:auto_follows</tt> - (to be implemented) automatic redirect following for specific types of returned combination of codes and methods.
  #
  # You can also store any other custom configuration.
  # 
  # ==== Example
  # 
  #   configuration = Configuration.new
  #   configuration[:entry_point] = 'http://resource.entrypoint.com/post'
  #   configuration[:entry_point] # => 'http://resource.entrypoint.com/post'
  # 
  # or you can use:
  # 
  #   configuration.entry_point = 'http://resource.entrypoint.com/post'
  #   configuration.entry_point # => 'http://resource.entrypoint.com/post'
  class Configuration < ::Hash

    # the current environment
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

    # this will store a new configuration (based on the default) for the environment passed by value.
    def environment=(value)
      @environment = value
      unless has_key?(@environment) 
        store(@environment,@@default_configuration.dup)
      end
      @environment
    end

    # access (key) configuration value
    def [](key)
      fetch(environment)[key]
    end

    # store on (key) configuration the value
    def []=(key,value)
      fetch(environment)[key] = value
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

  end
  
end
