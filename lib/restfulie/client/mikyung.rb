module Restfulie
  module Client
    module Mikyung
      autoload :WhenCondition, 'restfulie/client/mikyung/when_condition'
      autoload :ThenCondition, 'restfulie/client/mikyung/then_condition'
      autoload :RestProcessModel, 'restfulie/client/mikyung/rest_process_model'
      autoload :Concatenator, 'restfulie/client/mikyung/concatenator'
      autoload :Core, 'restfulie/client/mikyung/core'
      autoload :SteadyStateWalker, 'restfulie/client/mikyung/steady_state_walker'
      autoload :Languages, 'restfulie/client/mikyung/languages'
    end
  end
end

# Restfulie::Mikyung entry point is based on its core
# implementation.
module Restfulie
  class Mikyung < Restfulie::Client::Mikyung::Core
    # empty class
  end
end
