class Restfulie::Builder::Base
  attr_accessor :rules

  def initialize(rules = [])
    @rules = rules
  end

  # Remove to_json from ActiveSupport in the class
  # I want my own to_json
  undef_method :to_json if respond_to?(:to_json)

  def respond_to?(symbol, include_private = false)
    !marshalling_class(symbol).nil? || super
  end

  def method_missing(symbol, *args)
    unless (marshalling = marshalling_class(symbol)).nil?
      return marshalling.new(*args)
    end
    super
  end

private

  def marshalling_class(method)
    if marshalling_name = method.to_s.match(/to_(.*)/)
      marshalling = marshalling_name[1].downcase.capitalize.to_sym
      if Restfulie::Builder::Marshalling.const_defined?(marshalling)
        begin
          Restfulie::Builder::Marshalling.const_get(marshalling) 
        rescue NameError
          raise Restfulie::Error::UndefinedMarshallingError.new("Marshalling #{marshalling} not fould.")
        end
      end
    end
  end
end