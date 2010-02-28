$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'spec'
require 'ruby-debug'
require 'rexml/document'

require 'active_record'
require 'action_controller'

require 'restfulie/client'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3", "database" => File.join(File.dirname(__FILE__), '..', 'test.sqlite3')
)

load(File.dirname(__FILE__) + '/schema.rb')


class String
  def begins_with?(s)
    self[0, s.length]==s
  end
end
class StringBegin
  def initialize(content)
    @content = content
  end
  def matches?(k)
    k.begins_with?(@content)
  end
  def failure_message
    "Expected begin with '#{@content}'"
  end
end
def begin_with(x)
  StringBegin.new(x)
end
