require 'rubygems'
require 'spec'
require 'ruby-debug'

require 'active_support'
require 'action_controller'
require 'active_record'
require 'rails/version'

RAILS_ROOT = File.join(File.dirname(__FILE__), 'server', 'rails_app')
$:.unshift(RAILS_ROOT)

require 'rspec/rails'

require 'rexml/document'
require 'rcov'

require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'restfulie')
require File.join(File.dirname(__FILE__), 'lib', 'schema')

# Change output logger
Restfulie::Common::Logger.logger = ActiveSupport::BufferedLogger.new(File.join(File.dirname(__FILE__), "logs", "spec.log"))

ActionController::Base.view_paths = RAILS_ROOT + "/views" 

module ResponseMatchers

  class ResponseStatus

    def initialize(response_code)
      @expected_code = response_code.to_i
    end

    def matches?(response_header)
      @actual_code = response_header[2].code
      @expected_code == @actual_code
    end

    def failure_message
        "expected response status to be #{@expected_code} but it's #{@actual_code}"
    end

    def negative_failure_message
        "didn't expect #{@expected_code} to be #{@actual_code}"
    end

  end

  def respond_with_status(response_code)
    ResponseStatus.new(response_code)
  end

end

Spec::Runner.configure do |config|
   config.include(ResponseMatchers)
end