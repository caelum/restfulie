module Restfulie
  module VERSION #:nodoc:
    MAJOR = 1
    MINOR = 1
    TINY  = 1

    STRING = [MAJOR, MINOR, TINY].join('.')

    # Restfulie's version
    def self.to_s
      STRING
    end
  end
end
