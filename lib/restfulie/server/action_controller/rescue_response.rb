module Restfulie::Server::Rescue
  def self.custom_responses
    @customs ||= {}
  end

  custom_responses['Restfulie::Server::HTTP::UnsupportedMediaTypeError'] = :unsupported_media_type
  custom_responses['Restfulie::Server::HTTP::BadRequest'] = :bad_request

end  

module ActionController::Rescue

  # uses Restfulie::Server::Rescue registered exceptions to find an error code, otherwise
  # uses Rails default algorithm
  def response_code_for_rescue(exception)
    key = exception.class.name
    Restfulie::Server::Rescue.custom_responses[key] || rescue_responses[key]
  end
  
end
