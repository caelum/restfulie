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
