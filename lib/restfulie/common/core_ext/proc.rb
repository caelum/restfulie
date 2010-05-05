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

    m = extensible_module(block_caller)
    m.send(:define_method, :method_missing) do |symbol, *args, &block|
      mod = helpers.find { |h| h.respond_to?(symbol) }
      mod.nil? ? super : mod.send(symbol, *args, &block)
    end

    block_caller.extend(m)
    result = old_call(*args)
    m.send(:remove_method, :method_missing)

    result
  end

private

  # Search for extending the module in ancestors
  def extensible_module(object)
    ancestors  = object.instance_eval { (class << self; self; end) }.ancestors
    
    extend_mod = ancestors.find { |ancestor|
      !ancestor.instance_methods.include?("method_missing") && ancestor.instance_eval { (class << self; self; end) }.ancestors.include?(ProcIncludedHelpers)
    }

    if extend_mod.nil?    
      extend_mod = Module.new
      extend_mod.extend(ProcIncludedHelpers)
    end

    extend_mod
  end

  module ProcIncludedHelpers; end

end

