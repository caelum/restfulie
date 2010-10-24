class Restfulie::Client::Feature::SerializeBody
  
  def execute(flow, request, response, env)
    
    if should_have_payload?(request.method)
      
      payload = env[:body]
      if payload && !(payload.kind_of?(String) && payload.empty?)
        type = headers['Content-Type']
        raise Restfulie::Common::Error::RestfulieError, "Missing content type related to the data to be submitted" unless type
      
        marshaller = Restfulie::Common::Converter.content_type_for(type)
        raise Restfulie::Common::Error::RestfulieError, "Missing content type for #{type} related to the data to be submitted" unless marshaller

        rel = request.respond_to?(:rel) ? request.rel : ""
        env[:body] = marshaller.marshal(payload, { :rel => rel, :recipe => env[:recipe] })
      end
      
    end

    flow.continue(request, response, env)
  end
  
  protected
  
  PAYLOAD_METHODS = {:put=>true,:post=>true,:patch=>true}
  
  def should_have_payload?(method)
    PAYLOAD_METHODS[method]
  end
  
end
