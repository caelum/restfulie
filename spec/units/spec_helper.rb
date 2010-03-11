require 'rubygems'
require 'spec'

require 'ruby-debug'
require 'rexml/document'
require 'rcov'

require 'active_record'

require 'action_controller'
require 'action_controller/test_process'
require 'action_controller/test_case'
ApplicationController = Class.new(ActionController::Base)

require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'restfulie')
require File.join(File.dirname(__FILE__), 'lib', 'schema')

# Change output logger
Restfulie::Logger.logger = ActiveSupport::BufferedLogger.new(File.join(File.dirname(__FILE__), "logs", "spec.log"))

#
# Some steroids on Spec::Example::ExampleGroup.
#
class Spec::Example::ExampleGroup
  def normalize_xml(xml)
    REXML::Document.new(xml).to_s
  end
  
  def normalize_json(json)
    ActiveSupport::JSON.decode(json)
  end
end

class ActionController::TestCase
  extend Spec::Example::ExampleGroupMethods
  include Spec::Example::ExampleMethods

  prepend_before(:each) do
    run_callbacks :setup if respond_to?(:run_callbacks)
  end

  append_after(:each) do
    run_callbacks :teardown if respond_to?(:run_callbacks)
  end
end

Spec::Example::ExampleGroupFactory.register(:controller, ActionController::TestCase)

class AtomifiedModel 
  def to_atom(options={})
    Atom::Entry.new do |entry|
      entry.title     = "entry"
      entry.published = '123'
      entry.updated   = '123'
    end
  end
end
