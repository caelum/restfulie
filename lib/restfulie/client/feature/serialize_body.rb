# Feature responsible for marshalling the entity into the request body.
# It will use the request content type header to select the proper marshaller using Medie.
class Restfulie::Client::Feature::SerializeBody
  
  def execute(flow, request, env = {})
    
    if should_have_payload?(request.verb)
      
      env = env.dup
      payload = env[:payload] = env[:body]
      if payload && !(payload.kind_of?(String) && payload.empty?)
        type = request.headers['Content-Type']
        raise Restfulie::Common::Error::RestfulieError, "Missing content type related to the data to be submitted" unless type
      
        marshaller = Medie.registry.for(type)
        raise Restfulie::Common::Error::RestfulieError, "Missing content type for #{type} related to the data to be submitted" unless marshaller

        rel = request.respond_to?(:rel) ? request.rel : ""
        env[:body] = marshaller.marshal(payload, { :rel => rel, :recipe => env[:recipe] })
      end
      
    end

    flow.continue(request, env)
  end
  
  protected
  
  PAYLOAD_METHODS = {:put=>true,:post=>true,:patch=>true}
  
  def should_have_payload?(method)
    PAYLOAD_METHODS[method]
  end
  
end
