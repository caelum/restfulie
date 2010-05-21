class Restfulie::Client::SteadyStateWalker
  
  def move(goal, current, mikyung)
    step = goal.next_step(current)
    raise "No step was found for #{current} with links #{current.links}" unless step
    Restfulie::Common::Logger.logger.debug "Mikyung > next step will be #{step}"
    step = step.new if step.kind_of? Class
    try_to_execute(step, current, 3, mikyung)
  end

  private
  
  def try_to_execute(step, current, max_attempts, mikyung)
    raise "Unable to proceed when trying to #{step}" if max_attempts == 0

    resource = step.execute(current, mikyung)
    if resource==nil
      raise "Step returned 'give up'"
    end
    if resource.response.code != 200
      try_to_execute(step, max_attempts - 1)
    else
      Restfulie::Common::Logger.logger.debug resource.response.body
      resource
    end
  end

end