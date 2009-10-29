$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'spec'
require 'ruby-debug'

require 'active_record'

require 'restfulie'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3", "database" => File.join(File.dirname(__FILE__), '..', 'test.sqlite3')
)

load(File.dirname(__FILE__) + '/schema.rb')
