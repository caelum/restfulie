require 'rubygems'
require 'spec'

require 'ruby-debug'
require 'rexml/document'
require 'rcov'

require 'active_record'

require File.join(File.dirname(__FILE__), '..', 'lib', 'restfulie')
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
