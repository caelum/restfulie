module Restfulie::Marshalling
  @@marshallings_path = [File.join(File.dirname(__FILE__), 'marshallings')]
  mattr_accessor :marshallings_path

  class << self
    # Remove to_json from ActiveSupport in the class
    # I want my own to_json
    undef_method :to_json if respond_to?(:to_json)
    
    def respond_to?(symbol, include_private = false)
      unless (marshalling_name = parse_name(symbol)).nil?
        marshallings.include?(marshalling_name)
      else
        super
      end
    end

    def method_missing(symbol, *args)
      marshalling_name = parse_name(symbol)
      if !marshalling_name.nil? && marshallings.include?(marshalling_name)
        initialize_marshalling(marshalling_name)
      else
        super
      end
    end
    
    def marshallings
      @marshallings = [] unless defined? @marshallings
      register_marshallings
    end
    
    def load_marshalling(marshalling_name)
      if marshallings.include?(marshalling_name.to_s)
        marshalling_name = marshalling_name.to_s.capitalize
        begin
          "::#{self.ancestors.first}::#{marshalling_name}".constantize
        rescue NameError
          raise Restfulie::Error::UndefinedMarshallingError.new("Marshalling #{marshalling_name} not fould.")
        end
      end
    end
    
  private

    def parse_name(method)
      if marshalling_name = method.to_s.match(/to_(.*)/)
        marshalling_name[1]
      end
    end
  
    def register_marshallings
      self.marshallings_path.reject! do |path|
        Dir["#{path}/*.rb"].each do |file|
          marshalling_name = File.basename(file, ".rb").downcase
          @marshallings << marshalling_name unless @marshallings.include?(marshalling_name)
          self.autoload(marshalling_name.capitalize.to_sym, file) if self.autoload?(marshalling_name.capitalize.to_sym).nil?
        end
      end

      @marshallings
    end

    def initialize_marshalling(marshalling_name, *args)
      load_marshalling(marshalling_name).new(*args).to_s
    end

  end
end