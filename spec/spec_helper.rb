#
#  Copyright (c) 2009 Caelum - www.caelum.com.br/opensource
#  All rights reserved.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); 
#  you may not use this file except in compliance with the License. 
#  You may obtain a copy of the License at 
#  
#   http://www.apache.org/licenses/LICENSE-2.0 
#  
#  Unless required by applicable law or agreed to in writing, software 
#  distributed under the License is distributed on an "AS IS" BASIS, 
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
#  See the License for the specific language governing permissions and 
#  limitations under the License. 
#

require 'rubygems'
require 'spec'

require 'atom'
require 'ruby-debug'
require 'rexml/document'

require 'active_record'
require 'action_controller'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'restfulie'

ActiveRecord::Migration.verbose = false
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
  
  def normalize_json(json)
    ActiveSupport::JSON.decode(json)
  end
end