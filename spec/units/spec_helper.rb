require 'rubygems'
require 'spec'
require 'ruby-debug'

require 'active_support'
require 'action_controller'
require 'active_record'
require 'rails/version'

RAILS_ROOT = File.join(File.dirname(__FILE__), 'server', 'rails_app')
$:.unshift(RAILS_ROOT)

require 'spec/rails'

require 'rexml/document'
require 'rcov'

require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'restfulie')
require File.join(File.dirname(__FILE__), 'lib', 'schema')

# Change output logger
Restfulie::Common::Logger.logger = ActiveSupport::BufferedLogger.new(File.join(File.dirname(__FILE__), "logs", "spec.log"))

ActionController::Base.view_paths = RAILS_ROOT + "/views" 

class AtomifiedModel
  attr_writer   :new_record
  attr_reader   :updated_at
  
  def initialize(updated_at = Time.now)
    @updated_at = updated_at
  end

  def new_record?
    @new_record || false
  end

  def to_atom(options={})
    entry = Restfulie::Common::Representation::Atom::Entry.new
    entry.id        = "entry1"
    entry.title     = "entry"
    entry.updated   = Time.parse("2010-05-03T16:29:26Z")
    entry.published = Time.parse("2010-05-03T16:29:26Z")
    entry
  end
end

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