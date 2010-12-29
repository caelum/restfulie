require 'restfulie/common'

module Restfulie
  module Client
    autoload :MasterDelegator, 'restfulie/client/master_delegator'
    autoload :HTTP, 'restfulie/client/http'
    autoload :Configuration, 'restfulie/client/configuration'
    autoload :EntryPoint, 'restfulie/client/entry_point'
    autoload :Base, 'restfulie/client/base'
    autoload :Mikyung, 'restfulie/client/mikyung'
    autoload :Cache, 'restfulie/client/cache'
    autoload :Feature, 'restfulie/client/feature'
    autoload :Dsl, 'restfulie/client/dsl'
    autoload :StackNavigator, 'restfulie/client/stack_navigator'
    
    mattr_accessor :cache_provider, :cache_store

    Restfulie::Client.cache_store = ActiveSupport::Cache::MemoryStore.new
    Restfulie::Client.cache_provider = Restfulie::Client::Cache::Fake.new

  end
end

require 'restfulie/client/ext'
