module Restfulie
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 9
    TINY  = 0

    STRING = [MAJOR, MINOR, TINY].join('.')

    # Restfulie's version
    def self.to_s
      STRING
    end
  end
end
