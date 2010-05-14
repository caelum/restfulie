module Restfulie::Common::Converter::Components
  class Values
    attr_accessor :builder

    # BlankSlate
    instance_methods.each do |m|
      undef_method m unless m.to_s =~ /\[\]|method_missing|respond_to\?|^__/
    end

    def initialize(builder)
      @builder = builder
      @current_prefix = nil
    end

    def [](ns)
      @current_prefix = ns
      self
    end

    def method_missing(symbol, *args, &block)
      name = symbol.to_s
      prefix = @current_prefix
      @current_prefix = nil
      @builder.insert_value(name, prefix, *args, &block)
    end
  end
end
