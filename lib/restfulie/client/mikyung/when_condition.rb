class Restfulie::Client::Mikyung::WhenCondition

  def initialize(content, rule, params)
    @content = content
    @results = []
    @extra = []
    @rule = rule
    @params = params
  end
  
  def execute(resource, goal, mikyung)
    @results.each do |result|
      Restfulie::Common::Logger.logger.info("will '#{result.content}'")
      return result.execute(resource, goal, mikyung)
    end
  end

  def should_run_for(resource, goal)
    if @rule[1].arity==2
      rule_accepts = @rule[1].call(resource, @params)
    else
      rule_accepts = @rule[1].call(resource)
    end
    return false unless rule_accepts
    !@extra.find do |condition|
      !condition.should_run_for(resource, goal)
    end
  end
  
  def and(condition)
    @extra << condition
  end
  
  def results_on(result)
    @results << result
  end
  
end
