# a configuration error
module Restfulie
  module Client
    module Mikyung
      class ConfigurationError < Restfulie::Common::Error::RestfulieError
      end

      # Provides a DSL to build your process in a human readable way.
      #
      # Example:
      # When there is a machine
      # And  already installed
      # Then reboot
      #
      # Before creating your DSL you should provide your method content:
      #
      # When /there (are|is an|is a|is) (.*)/ do |resource, regex|
      #   resource.keys.first==regex[2]
      # end
      # 
      # When "already installed" do |resource|
      #   @installed
      # end
      # 
      # Then "reboot" do |resource|
      #   resource.machine.boot.post! :boot => {:reason => "Installed #{@software[:name]}"}
      # end
      class RestProcessModel
        
        # concatenates anything to a current expression
        def method_missing(sym, *args)
          Restfulie::Client::Mikyung::Concatenator.new(sym.to_s, *args)
        end
        
        # the list of results
        def then_rules
          @then_rules ||= []
        end
        
        # the list of conditions
        def conditions
          @conditions ||= []
        end
        
        # the list of conditional rules
        def when_rules
          @when_rules ||= []
        end
        
        # creates a When rule or block
        #
        # When blocks should return true or false whether the current resource matches what you expect:
        # When /there (are|is an|is a|is) (.*)/ do |resource, regex|
        #   resource.keys.first==regex[2]
        # end
        #
        # When rules will group conditions and rules together:
        # When there is a machine
        # And  already installed
        # Then reboot
        def When(concat, &block)
          if concat.respond_to? :content
            @condition = when_factory(concat)
            conditions << @condition
          else
            when_rules << [concat, block]
          end
        end
        
        # Adds a constraint to the current scenario
        def And(concat)
          @condition.and when_factory(concat)
        end
        
        # Adds a negative constraint to the current scenario
        def But(concat)
          @condition.but when_factory(concat)
        end
        
        # Creates a result rule
        #
        # example:
        # Then "reboot" do |resource|
        #   resource.machine.boot.post! :boot => {:reason => "Installed #{@software[:name]}"}
        # end
        def Then(concat, &block)
          if concat.respond_to? :content
            @condition.results_on Restfulie::Client::Mikyung::ThenCondition.new(concat.content)
          else
            then_rules << [concat, block]
          end
        end
      
        # Goes through every scenario and finds which one fits the current server steady state.
        # Picks this step and executes the business rule attached to it.
        def next_step(resource, mikyung)
          conditions.each do |c|
            if c.should_run_for(resource, self)
              return c.execute(resource, self, mikyung)
            end
          end
          nil
        end
        
        private
        
          def when_factory(concat)
            rule = when_rules.find do |rule|
              concat.content.match(rule[0])
            end
            if rule.nil?
              raise Restfulie::Client::Mikyung::ConfigurationError, "You forgot to create '#{concat.content}' prior to its usage."
            end
            Restfulie::Client::Mikyung::WhenCondition.new(concat.content, rule, concat.content.match(rule[0]))
          end
      end
    end
  end
end


