module Restfulie::Common::Converter::Components
  class Values
    attr_accessor :builder

    # BlankSlate
    instance_methods.each do |m|
      undef_method m unless m.to_s =~ /method_missing|respond_to\?|^__/
    end

    def initialize(builder)
      @builder = builder
    end

    def method_missing(symbol, *args, &block)
      name = symbol.to_s
      if name =~ /=$/
        @builder.insert(name.chop, args.first)
      elsif block_given?
        @builder.insert(name, *args, &block)
      end
    end
  end
end
