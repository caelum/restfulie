module Restfulie
  module Client
    module HTTP
      module Cache
        def store
          @store || @store = ::ActiveSupport::Cache::MemoryStore.new
        end
    
        def get
          store.fetch(@uri) do
            request(:get, @uri, @headers)
          end
        end
    
        def head
          store.fetch(@uri) do
            request(:head, @uri, @headers)
          end
        end
    
      end
    
      class RequestBuilderExecutorWithCache < RequestBuilderExecutor
        include Cache
      end
    end
  end
end

