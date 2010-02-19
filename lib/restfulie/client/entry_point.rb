module Restfulie::Client
  class FollowConfig
    def initialize
      @entries = {
        :moved_permanently => [:get, :head]
      }
    end
    def method_missing(name, *args)
      return value_for(name) if name.to_s[-1,1] == "?"
      set_all_for name
    end
    
  private
    def set_all_for(name)
      @entries[name] = :all
    end
    def value_for(name)
      return @entries[name.to_s.chop.to_sym]
    end
  end
  
  class EntryPointControl
    
    def initialize(type)
      @type = type
      @entries = {}
    end
    
    def method_missing(name, *args)
      @entries[name] ||= EntryPoint.new
      @entries[name]
    end

  end
  
  class EntryPoint
    attr_accessor :uri

    def self.at(uri)

    end

    def at(uri)
      @uri = uri
    end
  end
end
