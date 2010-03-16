module Restfulie::Common::Error
  class RestfulieError < StandardError; end
  class MarshallingError < RestfulieError; end
  class UndefinedMarshallingError < MarshallingError; end
end
