# Simple feature that returns the exception in case it occurs.
# This feature is automatically loaded in the stack.
class Restfulie::Client::Feature::RescueException
  
  def execute(flow, request, env)
    begin
      flow.continue(request, env)
    rescue Exception => e
      e
    end
  end
  
end
