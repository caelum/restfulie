module Restfulie::Client::HTTP
  module ResponseHolder
    attr_reader :response, :request
    
    def resource
      type = headers['content-type'] || response['Content-Type']
      representation = Restfulie::Common::Converter.content_type_for(type[0]) || Restfulie::Common::Representation::Generic.new
      representation.unmarshal(response.body)
    end
    
    def at(uri)
      request.clone.at(uri)
    end
    
    def headers
      response.to_hash
    end
    
    def results_from(request, response)
      @request = request
      @response = response
    end
        
  end
end
