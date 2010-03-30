module Restfulie::Client #:nodoc:

  # Use this class to configure the entry point and other relevant behaviors related to accessing or interacting with resources
  # 
  # The available options are:
  # 
  # * <tt>:entry_point</tt> - The URI for an entry point, such as http://resource.entrypoint.com/post
  # * <tt>:representations</tt> - Representations.
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
      :representations => {}
    }

    def initialize
      super
      self.environment = :development
    end

    # this will store a new configuration (based on the default) for the environment passed by value.
    def environment=(value)
      @environment = value
      unless has_key?(@environment) 
        dee_clone = Marshal::load(Marshal::dump(@@default_configuration))
        store(@environment,dee_clone)
      end
      @environment
    end

    # access (key) configuration value
    def [](key)
      fetch(@environment)[key]
    end

    # store on (key) configuration the value
    def []=(key,value)
      fetch(@environment)[key] = value
    end 

    def method_missing(name, *args, &block)
      method_name = name.to_s
      if method_name.last == '='
        fetch(environment)[method_name.chop.to_sym] = args[0]
      else
        value = fetch(environment)[name]
        value ? value : super
      end
    end

  end
  
end
