
class Concatenator
  attr_reader :content
  def initialize(content, *args)
    @content = content
    args.each do |arg|
      @content << " " << arg.content
    end
    # puts "Created concatenator #{@content}"
  end
end


class WhenCondition
  attr_reader :results, :extra
  def initialize(content, rule, params)
    @content = content
    @results = []
    @extra = []
    @rule = rule
    @params = params
  end
  
  def execute(resource, goal, mikyung)
    results.each do |result|
      Restfulie::Common::Logger.logger.debug("will execute #{result}")
      return result.execute(resource, goal, mikyung)
    end
  end

  def test_for(resource, goal)
    if @rule[1].arity==2
      rule_accepts = @rule[1].call(resource, @params)
    else
      rule_accepts = @rule[1].call(resource)
    end
    return false unless rule_accepts
    !extra.find do |condition|
      !condition.test_for(resource, goal)
    end
  end
  
end

class ThenCondition
  def initialize(content)
    @content = content
  end
  
  def execute(resource, goal, mikyung)
    goal.then_rules.each do |rule|
      if Regexp.new(rule[0]).match(@content)
        matches = Regexp.new(rule[0]).match(@content)
        if rule[1].arity==1
          found_rule = rule[1].call(resource)
        else
          found_rule = rule[1].call(resource, matches, mikyung)
        end
        return found_rule
      end
    end
    nil
  end
end

class Mikyung::RestProcessModel
  def method_missing(sym, *args)
    # puts "#{sym} #{args}"
    Concatenator.new(sym.to_s, *args)
  end
  
  def then_rules
    @then_rules ||= []
  end
  def conditions
    @conditions ||= []
  end
  def when_rules
    @when_rules ||= []
  end
  
  def When(concat, &block)
    if concat.respond_to? :content
      @condition = when_factory(concat)
      conditions << @condition
    else
      when_rules << [concat, block]
    end
  end
  
  private
  
  def when_factory(concat)
    rule = when_rules.find do |rule|
      concat.content.match(rule[0])
    end
    WhenCondition.new(concat.content, rule, concat.content.match(rule[0]))
  end
  
  public
  
  def And(concat)
    @condition.extra << when_factory(concat)
  end
  
  def But(concat)
    # WhenCondition.new(concat.content)
  end
  
  def Then(concat, &block)
    if concat.respond_to? :content
      @condition.results << ThenCondition.new(concat.content)
    else
      then_rules << [concat, block]
    end
  end

  def next_step(resource, mikyung)
    conditions.each do |c|
      if c.test_for(resource, self)
        return c.execute(resource, self, mikyung)
      end
    end
    nil
  end

end

class Restfulie::Client::SteadyStateWalker

  def try_to_execute(step, current, max_attempts, mikyung)
    raise "Unable to proceed when trying to #{step}" if max_attempts == 0

    resource = step
    if resource==nil
      raise "Step returned 'give up'"
    end
    if resource.response.code != 200
      try_to_execute(step, current, max_attempts-1, mikyung)
    else
      Restfulie::Common::Logger.logger.debug resource.response.body
      resource
    end
  end
end
