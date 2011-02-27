module Restfulie
  module VERSION #:nodoc:
    MAJOR = 1
    MINOR = 0
    TINY  = 2

    STRING = [MAJOR, MINOR, TINY].join('.')

    # Restfulie's version
    def self.to_s
      STRING
    end
  end
end
