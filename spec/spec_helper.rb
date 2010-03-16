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

require File.join(File.dirname(__FILE__), '..', 'lib', 'restfulie')
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
    Atom::Entry.new do |entry|
      entry.title     = "entry"
      entry.published = '123'
      entry.updated   = '123'
    end
  end
end