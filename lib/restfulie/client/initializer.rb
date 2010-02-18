module Retifulie::Client

  class Initializer

    attr_accessor :configuration

    def self.run(command = :process, configuration = Configuration.new)
      yield configuration if block_given?
      initializer = new configuration
      initializer.send(command)
      initializer
    end

    def initialize(configuration)
      @configuration = configuration
    end

    def process
    end

  end

end

