module Restfulie
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 8
    TINY  = 0

    STRING = [MAJOR, MINOR, TINY].join('.')

    def self.to_s
      STRING
    end
  end
end
