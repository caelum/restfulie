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
    Restfulie::Client::Mikyung::WhenCondition.new(concat.content, rule, concat.content.match(rule[0]))
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
      @condition.results_on Restfulie::Client::Mikyung::ThenCondition.new(concat.content)
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
