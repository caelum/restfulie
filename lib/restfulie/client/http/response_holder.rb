module Restfulie
  module Client
    module HTTP
      module ResponseHolder
        attr_accessor :response
        
        def resource
          type = response.respond_to?(:headers) ? response.headers['content-type'] : response['content-type']
          representation = Restfulie::Client::HTTP::RequestMarshaller.content_type_for(type) || Restfulie::Common::Representation::Generic.new
          representation.unmarshal(response.body)
        end
      end
    end
  end
end
