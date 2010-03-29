module Restfulie::Server::Rescue
  def self.custom_responses
    @customs ||= {}
  end

  custom_responses['Restfulie::Server::HTTP::UnsupportedMediaTypeError'] = :unsupported_media_type
  custom_responses['Restfulie::Server::HTTP::BadRequest'] = :bad_request

end  

module ActionController::Rescue

  def response_code_for_rescue(exception)
    key = exception.class.name
    return Restfulie::Server::Rescue.custom_responses[key] if Restfulie::Server::Rescue.custom_responses[key]
    rescue_responses[key]
  end
  
end
