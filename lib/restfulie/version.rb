module Restfulie
  module VERSION #:nodoc:
    MAJOR = 1
    MINOR = 0
    TINY  = 0

    STRING = [MAJOR, MINOR, TINY].join('.') + ".beta3"

    # Restfulie's version
    def self.to_s
      STRING
    end
  end
end
