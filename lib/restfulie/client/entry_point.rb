module Restfulie::Client
  
  module EntryPoint
    include ::Restfulie::Client::HTTP::RequestBuilder
    extend self

    def request!(method, path, *args)
      response = super(method, path, *args)
      response.unmarshal
    end

  end

end
