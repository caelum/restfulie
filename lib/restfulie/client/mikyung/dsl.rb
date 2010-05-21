
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
