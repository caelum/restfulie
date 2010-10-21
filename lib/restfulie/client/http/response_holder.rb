module Restfulie
  module Client
    module HTTP
      module ResponseHolder
        attr_accessor :response
        
        def resource
          type = headers['content-type'] || response['Content-Type']
          representation = Restfulie::Client::HTTP::RequestMarshaller.content_type_for(type[0]) || Restfulie::Common::Representation::Generic.new
          representation.unmarshal(response.body)
        end
        
        def headers
          response.to_hash
        end
        
      end
    end
  end
end
