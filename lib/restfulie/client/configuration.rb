module Restfulie::Client

  class Configuration

    @@default_configuration = {
      :hosts => []
    }

    attr_reader :environment

    def initialize(file='./config/restifulie_client.yml',env=:development)
      if ::File.exist?(file)
        self.read file, env
      else
        @@config = { env => @@default_configuration.dup }
        self.environment = env
      end
    end

    def read(file,env=:development)
      raise "Undefined file" if file.nil?
      raise "File #{file} not found" unless ::File.exist?(file)
      @@config = ::YAML.load_file(file)
      self.environment = env.to_sym
    end

    def environment=(env)
      raise "Undefined env" if env.nil?
      @@env = env
      load_config @environment = env
    end

    def self.[](conf_name)
      @@config[@@env.to_sym][conf_name]
    end

    private
    def load_config(env)
      raise "Undefined configuration" if @@config.nil?
      key = env
      raise "Undefined env=#{key} in config=#{@@config.inspect}" unless @@config.has_key?(key)
    end

  end
  
end
