class Restfulie::Builder::Base
  attr_accessor :rules_blocks
  attr_accessor :object
  
  # TODO: Configurable
  OPTIONS_DEFAULT = {
    :eagerload => true,
    :default_rule => true
  }

  def initialize(object, rules_blocks = [], options = {})
    @options = OPTIONS_DEFAULT.merge(options)
    @object  = object
    @rules_blocks = rules_blocks
  end

  # Remove to_json from ActiveSupport in the class
  # I want my own to_json
  undef_method :to_json if respond_to?(:to_json)

  def respond_to?(symbol, include_private = false)
    !marshalling_class(symbol).nil? || super
  end

  def method_missing(symbol, *args)
    unless (marshalling = marshalling_class(symbol)).nil?
      return builder(marshalling, *args)
    end
    super
  end

private

  def builder(marshalling, options = {})
    @object.class.ancestors.include?(Enumerable) ? builder_collection(marshalling, options) : builder_member(marshalling, options)
  end

  def builder_member(marshalling, options = {})
    marshalling.new(@object, rules_blocks).builder_member(@options.merge(options))
  end

  def builder_collection(marshalling, options = {})
    marshalling.new(@object, rules_blocks).builder_collection(@options.merge(options))
  end

  def marshalling_class(method)
    if marshalling_name = method.to_s.match(/to_(.*)/)
      marshalling = marshalling_name[1].downcase.capitalize.to_sym
      if Restfulie::Builder::Marshalling.const_defined?(marshalling)
        begin
          Restfulie::Builder::Marshalling.const_get(marshalling) 
        rescue NameError
          raise Restfulie::Error::UndefinedMarshallingError.new("Marshalling #{marshalling} not found.")
        end
      end
    end
  end
end