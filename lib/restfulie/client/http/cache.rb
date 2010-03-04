module Restfulie::Client::HTTP::Cache

  module RequestBuilder
    include ::Restfulie::Client::HTTP::RequestBuilder

    mattr_accessor :store
    @@store = ::ActiveSupport::Cache::MemoryStore.new

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

  class RequestBuilderExecutor 
    include RequestBuilder
    def initialize(host, default_headers = {})
      self.host=host
      self.default_headers=default_headers
    end
    def at(path)
      @path = path
      self
    end
    def path
      @path
    end
  end

end

