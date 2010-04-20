module Restfulie::Common::Error
  class RestfulieError < StandardError; end
  class MarshallingError < RestfulieError; end
  class UndefinedMarshallingError < MarshallingError; end
  
  # Atom marshallinh error
  class AtomMarshallingError < MarshallingError; end
  class NameSpaceError < AtomMarshallingError; end

  # Converter
  class ConverterError < RestfulieError; end
  
  # builder
  class BuilderError < RestfulieError; end
end
