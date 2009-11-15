$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'spec'
require 'ruby-debug'
require 'rexml/document'

require 'active_record'
require 'action_controller'

require 'restfulie_controller'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3", "database" => File.join(File.dirname(__FILE__), '..', 'test.sqlite3')
)

load(File.dirname(__FILE__) + '/schema.rb')

#
# Some steroids on Spec::Example::ExampleGroup.
#
class Spec::Example::ExampleGroup
  def normalize_xml(xml)
    REXML::Document.new(xml).to_s
  end
end