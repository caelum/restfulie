# A conclusion to a step.
#
# Whenever a step rule matches, there are a series of conditions to be executed.
class Restfulie::Client::Mikyung::ThenCondition
  
  attr_reader :description
  
  # creates a new result, based on this description
  def initialize(description)
    @description = description
  end
  
  # finds the rule for this result and executes it
  def execute(resource, goal, mikyung)
    goal.then_rules.each do |rule|
      if (matches = Regexp.new(rule[0]).match(@description))
        return invoke_rule(rule[1], resource, matches, mikyung)
      end
    end
    nil
  end
  
  private
  def invoke_rule(rule, resource, matches, mikyung)
    if rule.arity==1
      rule.call(resource)
    elsif rule.arity==2
      rule.call(resource, matches)
    else
      rule.call(resource, matches, mikyung)
    end
  end
end