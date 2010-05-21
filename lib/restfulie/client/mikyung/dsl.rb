
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

class Restfulie::Client::Mikyung::RestProcessModel
  def method_missing(sym, *args)
    # puts "#{sym} #{args}"
    Restfulie::Client::Mikyung::Concatenator.new(sym.to_s, *args)
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
    @condition.and when_factory(concat)
  end
  
  def But(concat)
    # WhenCondition.new(concat.content)
  end
  
  def Then(concat, &block)
    if concat.respond_to? :content
      @condition.results_on ThenCondition.new(concat.content)
    else
      then_rules << [concat, block]
    end
  end

  def next_step(resource, mikyung)
    conditions.each do |c|
      if c.should_run_for(resource, self)
        return c.execute(resource, self, mikyung)
      end
    end
    nil
  end

end

module Restfulie::Client::Mikyung::German
  def Wenn(concat, &block)
    When(concat, &block)
  end
  def Und(concat, &block)
    And(concat, &block)
  end
  def Aber(concat, &block)
    But(concat, &block)
  end
  def Dann(concat, &block)
    Then(concat, &block)
  end
end

module Restfulie::Client::Mikyung::Portuguese
  def Quando(concat, &block)
    When(concat, &block)
  end
  def E(concat, &block)
    And(concat, &block)
  end
  def Mas(concat, &block)
    But(concat, &block)
  end
  def Entao(concat, &block)
    Then(concat, &block)
  end
end

class Restfulie::Client::Mikyung::SteadyStateWalker

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
