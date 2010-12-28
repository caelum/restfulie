module Restfulie::Client::HTTP
  module ResponseHolder
    attr_reader :response, :request
    
    def resource
      type = headers['content-type'] || response['Content-Type']
      representation = Medie.registry.for(type[0])
      representation.unmarshal(response.body)
    end
    
    def at(uri)
      request.clone.at(uri)
    end
    
    def headers
      response.to_hash.extend(::Restfulie::Client::HTTP::LinkHeader)
    end
    
    def results_from(request, response)
      @request = request
      @response = response
    end

    def verb
      @request.verb
    end
        
  end
end
