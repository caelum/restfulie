class Proc
  attr_accessor :helpers
  alias_method :old_call, :call

  def call(*args)
    @helpers.nil? ? old_call(*args): call_include_helpers(@helpers, *args)
  end

  def call_include_helpers(helpers, *args)
    helpers      = [helpers] unless helpers.kind_of?(Array) 
    helpers      = helpers.map { |helper| Object.new.send(:extend, helper) }
    block_caller = eval("self", self.binding)
    meta_class   = block_caller.instance_eval { (class << self; self; end) }

    old_missing_method = "__modincluded_#{Thread.current.object_id.abs}".to_sym

    meta_class.send(:alias_method, old_missing_method, :method_missing) if block_caller.respond_to?(:method_missing)
    meta_class.send(:define_method, :method_missing) do |symbol, *args|
      begin
        begin
          helpers.find { |h| h.respond_to?(symbol) }.send(symbol, *args)
        rescue
          super
        end
      rescue NoMethodError => e
        error = NameError.new("undefined local variable or method `#{symbol}` for #{block_caller}")
        error.set_backtrace(caller[0..0] + caller[5..-1])
        raise error
      end
    end

    result = old_call(*args)

    meta_class.send(:undef_method, :method_missing)
    meta_class.send(:alias_method, :method_missing, old_missing_method) if block_caller.respond_to?(old_missing_method)

    result
  end
end

